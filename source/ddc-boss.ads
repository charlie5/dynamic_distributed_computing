with
     DDC.Worker;


package DDC.Boss
--
-- The central manager which distributes jobs and collects/collates partial calculation results.
--
is
   pragma remote_call_Interface;


   -- Remote views.
   --

   type remote_Worker  is access all DDC.Worker.item'Class
     with Asynchronous => True;


   -- Operations
   --

   procedure add (the_Worker : in remote_Worker;   Id : out worker_Id);
   procedure rid (the_Worker : in remote_Worker);

   procedure calculate;
   procedure accept_partial (Result : in Float;
                             From   : in remote_Worker);

end DDC.Boss;
