package DDC
--
-- Top-level namespace package for the 'Dynamic Distributed Computing' demonstration.
--
is
   pragma Pure;

   type worker_Id is new Positive;
   type Samples   is array (Integer range <>) of Float;

end DDC;
