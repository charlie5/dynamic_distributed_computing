with
     Ada.Containers.Vectors,
     Ada.Text_IO;

package body DDC.Boss
is

   use DDC.Worker,
       Ada.Text_IO;


   ----------
   -- Workers
   --

   package Worker_vectors is new Ada.Containers.Vectors (Positive, remote_Worker);
   use worker_Vectors;

   subtype Worker_vector is Worker_vectors.Vector;


   protected ready_Workers
   is
      procedure get_next_Available (the_Worker : out remote_Worker);

      procedure add (the_Worker : in remote_Worker);
      procedure rid (the_Worker : in remote_Worker);

   private
      Workers : Worker_vector;
   end ready_Workers;


   protected body ready_Workers
   is

      procedure get_next_Available (the_Worker : out remote_Worker)
      is
      begin
         if Workers.Is_Empty
         then
            the_Worker := null;
            return;
         end if;

         the_Worker := Workers.last_Element;
         Workers.delete_Last;
      end get_next_Available;


      procedure add (the_Worker : in remote_Worker)
      is
      begin
         Workers.prepend (the_Worker);
      end add;


      procedure rid (the_Worker : in remote_Worker)
      is
      begin
         Workers.delete (Workers.find_Index (the_Worker));
      end rid;

   end ready_Workers;



   function next_available_Worker return remote_Worker
   is
      use Ada.Containers;
      the_Worker : remote_Worker;
   begin
      loop
         ready_Workers.get_next_Available (the_Worker);

         if the_Worker /= null
         then
            return the_Worker;
         end if;
      end loop;
   end next_available_Worker;



   --------------
   -- Calculation
   --

   protected current_Average
   is
      function  Value      return Float;
      procedure add (Partial : in Float);

      function  Count return Natural;
   private
      Average       : Float   := 0.0;
      partial_Count : Natural := 0;
   end current_Average;


   protected body current_Average
   is
      function  Value return Float
      is
      begin
         return Average / Float (partial_Count);
      end Value;

      procedure add (Partial : in Float)
      is
      begin
         Average       := Average + Partial;
         partial_Count := partial_Count + 1;
      end add;

      function  Count return Natural
      is
      begin
         return partial_Count;
      end Count;
   end current_Average;



   -- Samples
   --
   total_sample_Count : constant := 10_000_000;
   all_Samples        : Samples (1 .. total_sample_Count);


   -- Job Samples
   --
   job_samples_Count : constant := 1_000;

   subtype job_Samples is Samples (1 .. job_samples_Count);


   -- Jobs
   --
   job_Count : constant := total_sample_Count / job_samples_Count;
   next_Job  : Positive := 1;     -- Index of the next job to be done.



   -------------
   -- Operations
   --

   procedure calculate
   is
      the_final_Average : Float;
   begin
      put_Line ("Boss begins 'Average' calculation.");

      -- Distribute the jobs.
      --
      loop
         declare
            available_Worker : constant remote_Worker := next_available_Worker;

            First       : constant Integer     := 1  +  (next_Job - 1) * job_samples_Count;
            Last        : constant Integer     :=        next_Job      * job_samples_Count;
            the_Samples : constant job_Samples := all_Samples (First .. Last);
         begin
            available_Worker.process (the_Samples);
         end;

         next_Job := next_Job + 1;
         exit when next_Job > job_Count;
      end loop;


      -- Wait until all jobs are completed.
      --
      while current_Average.Count < job_Count
      loop
         delay 0.1;
      end loop;

      -- Calculate the final result.
      --
      the_final_Average := current_Average.Value;

      put_Line ("Boss: Average is" & Float'Image (the_final_Average));
   end calculate;



   procedure accept_partial (Result : in Float;
                             From   : in remote_Worker)
   is
   begin
      current_Average.add (Partial => Result);
      ready_Workers  .add (From);
   end accept_partial;



   protected next_Id
   is
      procedure get (Id : out worker_Id);
   private
      Next : worker_Id := 1;
   end next_Id;


   protected body next_Id
   is
      procedure get (Id : out worker_Id)
      is
      begin
         Id   := Next;
         Next := Next + 1;
      end get;
   end next_Id;



   procedure add (the_Worker : in     remote_Worker;
                  Id         :    out worker_Id)
   is
   begin
      next_Id.get (Id);
      ready_Workers.add (the_Worker);
   end add;



   procedure rid (the_Worker : in remote_Worker)
   is
   begin
      ready_Workers.rid (the_Worker);
   end rid;



begin
   -- Initialise the value of each sample.
   --
   for i in all_Samples'Range
   loop
      all_Samples (i) := Float (i);
   end loop;

end DDC.Boss;
