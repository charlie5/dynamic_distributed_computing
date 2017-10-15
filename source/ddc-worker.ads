package DDC.Worker
is
   pragma remote_Types;


   type Item is abstract tagged limited private;

   procedure process (Self : access Item;   the_Samples : in Samples)   is abstract;


private

   type Item is abstract tagged limited null record;

end DDC.Worker;

