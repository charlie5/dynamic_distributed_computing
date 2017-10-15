with
     DDC.Boss,
     Ada.Text_IO;


package body DDC.Worker.local
is

   procedure define (Self : access Item)
   is
   begin
      -- Register the worker with the boss.
      --
      DDC.Boss.add (the_Worker => Self.all'Access,
                    Id         => Self.Id);
   end define;



   overriding
   procedure process (Self : access Item;   the_Samples  : in Samples)
   is
      use Ada.Text_IO;

      Total   : Float := 0.0;
      Average : Float;
   begin
      put_Line ("Worker" & worker_Id'Image (Self.Id) & " is processing");

      for i in the_Samples'Range
      loop
         Total := Total + the_Samples (i);
      end loop;

      Average := Total / Float (the_Samples'Length);

      DDC.Boss.accept_partial (Result => Average,
                               From   => Self.all'Access);
   end process;


end DDC.Worker.local;

