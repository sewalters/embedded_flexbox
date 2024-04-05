with STM32.Board; use STM32.Board;
with HAL.Touch_Panel; use HAL.Touch_Panel;
with Ada.Real_Time;   use Ada.Real_Time;
with dui;             use dui;
with Event_Controller; use Event_Controller;
package body event_handler is
    task body Generate_Event_Snapshot is
        wait_time : Time      := Ada.Real_Time.Clock;
        period    : Time_Span := Ada.Real_Time.Milliseconds (15);
        writer_snap : event_snap;
        drag_counter : Natural := 0; --counts up to 10. If counter reaches 10. Send Drag instead of press.
    begin
        loop
            declare
                State : constant TP_State :=
                   STM32.Board.Touch_Panel.Get_All_Touch_Points;
            begin
                if State'Length < 1 then
                    writer_snap.x1 := 0;
                    writer_snap.y1 := 0;
                    writer_snap.x2 := 0;
                    writer_snap.y2 := 0;
                    writer_snap.S := no;
                    drag_counter := 0;
                    Event_Controller.Set(writer_snap);
                elsif State'Length = 1 and drag_counter < 20 then
                    writer_snap.x1 := State(1).x;
                    writer_snap.y1 := State(1).y;
                    writer_snap.x2 := 0;
                    writer_snap.y2 := 0;
                    writer_snap.S := press;
                    Event_Controller.Set(writer_snap);
                    drag_counter := drag_counter + 1;
                elsif State'Length = 1 and drag_counter >= 20 then
                    writer_snap.x1 := State(1).x;
                    writer_snap.y1 := State(1).y;
                    writer_snap.x2 := 0;
                    writer_snap.y2 := 0;
                    writer_snap.S :=  drag;
                    Event_Controller.Set(writer_snap);
                elsif State'Length = 2 then
                    writer_snap.x1 := State(1).x;
                    writer_snap.y1 := State(1).y;
                    writer_snap.x2 := State(2).x;
                    writer_snap.y2 := State(2).y;
                    writer_snap.S := resize;
                    drag_counter := 0;
                    Event_Controller.Set(writer_snap);
                else
                    writer_snap.x1 := State(1).x;
                    writer_snap.y1 := State(1).y;
                    writer_snap.x2 := State(2).x;
                    writer_snap.y2 := State(2).y;
                    writer_snap.S := resize;
                    drag_counter := 0;
                    Event_Controller.Set(writer_snap);
                end if;
                wait_time := wait_time + period;
                delay until wait_time;
            end;
        end loop;
    end Generate_Event_Snapshot;
end event_handler;
