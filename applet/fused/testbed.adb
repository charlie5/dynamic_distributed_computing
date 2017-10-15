with
     DDC.Boss,
     DDC.Worker.local,

     Ada.Text_IO,
     Ada.Exceptions;


package body Testbed
is

   use DDC,
       Ada.Exceptions,
       Ada.text_io;


   -- 'Server' environment task
   --
   task boss_Environment
   is
      entry open;
   end boss_Environment;



   -- 'Worker 1' environment task
   --
   task Worker_1_Environment
   is
      entry open;
   end Worker_1_Environment;



   -- 'Worker 2' environment task
   --
   task Worker_2_Environment
   is
      entry open;
   end Worker_2_Environment;



   --- Simulate the 'Boss' environment task.
   --

   task body boss_Environment
   is
   begin
      accept open;
      DDC.Boss.calculate;

   exception
      when the_Error : others =>
         put_Line ("testbed boss_Environment task *fatal* exception:");
         put_Line (exception_Information (the_Error));
         put_Line (exception_Message     (the_Error));
   end boss_Environment;



   --- Simulate the 'Worker 1' environment task.
   --

   Worker_1 : constant DDC.Worker.local.view := new DDC.Worker.local.item;


   task body Worker_1_Environment
   is
   begin
      accept open;

      Worker_1.define;
--        Worker_1.destroy;

   exception
      when the_Error : others =>
         put_Line ("testbed Worker 1 task *fatal* exception:");
         put_Line (exception_Information (the_Error));
         put_Line (exception_Message     (the_Error));
   end Worker_1_Environment;



   --- Simulate the 'Worker 2' environment task.
   --

   Worker_2 : constant DDC.Worker.local.view := new DDC.Worker.local.item;


   task body Worker_2_Environment
   is
   begin
      accept open;

      Worker_2.define;
--        Worker_2.destroy;

   exception
      when the_Error : others =>
         put_Line ("testbed Worker 2 task *fatal* exception:");
         put_Line (exception_Information (the_Error));
         put_Line (exception_Message     (the_Error));
   end Worker_2_Environment;



   procedure open
   is
   begin
      boss_Environment.open;

      delay 1.0;
      Worker_1_Environment.open;

      delay 3.0;
      Worker_2_Environment.open;
   end open;


end Testbed;
