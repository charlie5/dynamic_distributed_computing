with
     DDC.Worker.local,

     Ada.Exceptions,
     Ada.Text_IO;


procedure launch_DDC_Worker
is
   use Ada,
       Ada.Exceptions,
       Ada.Text_IO;

   Self : constant DDC.Worker.local.view := new DDC.Worker.local.item;

begin
   Self.define;

exception
   when the_Error : others =>
      put_Line ("Worker has *fatal* exception:");
      put_Line (exception_Information (the_Error));
      put_Line (exception_Message     (the_Error));

end launch_DDC_Worker;
