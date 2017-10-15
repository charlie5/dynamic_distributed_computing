with
     DDC.Boss,
     Ada.Text_IO,
     Ada.Exceptions;


procedure launch_DDC_Boss
is
   use Ada.Text_IO,
       Ada.Exceptions;
begin
   DDC.Boss.calculate;

exception
   when the_Error : others =>
      put_Line ("Boss has *fatal* exception:");
      put_Line (exception_Information (the_Error));
      put_Line (exception_Message     (the_Error));

end launch_DDC_Boss;
