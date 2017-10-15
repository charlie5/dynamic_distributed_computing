package DDC.Worker.local
--
-- Provides a concrete Worker.
--
is

   type Item is limited new DDC.Worker.item with private;
   type View is access all Item'Class;

   type Views is array (Positive range <>) of View;


   procedure define  (Self : access Item);

   overriding
   procedure process (Self : access Item;   the_Samples  : in Samples);


private

   type Item is limited new DDC.Worker.item with
      record
         Id : worker_Id;
      end record;

end DDC.Worker.local;

