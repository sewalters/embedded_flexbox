package Event_Controller is
        type Event_State is (idle, press, resize);
        type Event_Snap is record
            X1, X2, Y1, Y2 : Natural;
            S              : Event_State;
        end record;
        function Get return Event_Snap;
        procedure Set (E : Event_Snap);  
end Event_Controller;