package body Event_Controller is

    protected type Event_Rec is
        procedure Set_Event_Snapshot (E : event_snap);
        function Get_Event_Snapshot return event_snap;
    private
        ES : event_snap;
    end Event_Rec;

    protected body Event_Rec is
        procedure Set_Event_Snapshot (E : event_snap) is
        begin
            ES := E;
        end Set_Event_Snapshot;

        function Get_Event_Snapshot return event_snap is
           (ES);
    end Event_Rec;

    P : Event_Rec;

    function Get return Event_Snap is
       (P.Get_Event_Snapshot);

    procedure Set (E : Event_Snap) is
    begin
      P.Set_Event_Snapshot(E);
    end;

end Event_Controller;
