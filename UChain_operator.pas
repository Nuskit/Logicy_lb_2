unit UChain_operator;

interface
const
  CODE_SPACE=#32;

  procedure search_all_jump(const working_text:string);
  procedure set_stack_jumps(const working_text:string);

implementation

uses
  UAnalyze_text,UConstant;

type

  TOperator_State=(not_visited,visited,is_proc,called_proc,not_found);
  TDynamicBool=array of TOperator_State;

  TStack_operator_number=record
    stack_amount:integer;
    stack_data:array of integer;
  end;

  TStack_operator_state=record
    stack_amount:integer;
    stack_data:array of Toperator_state;
  end;



const
  CODE_NOT_FOUND_ARGUMENT=-1;

var
  Stack_operator_number:TStack_operator_number;
  Stack_operator_state:TStack_operator_state;

function search_possible_label_name(const working_text:string;
 operator_information:Toperator_information):string;
var
  position_label_start,position_label_end:integer;
  len_working_text:integer;
begin
  len_working_text:=length(working_text);
  with operator_information do
    position_label_start:=operator_position+length(operators_all[operator_position_in_array_table]);
  while (position_label_start<=len_working_text) and
   (working_text[position_label_start]=code_space) do
    inc(position_label_start);

  position_label_end:=position_label_start;
  while (position_label_end<=len_working_text) and
   (working_text[position_label_end]<>Code_space) do
    inc(position_label_end);

  result:=copy(working_text,position_label_start,position_label_end-position_label_start);
end;

function search_label_by_name(const possible_label_name:string):integer;
var
  i,number_found_label:integer;
  found_label_number:boolean;
begin
  number_found_label:=CODE_NOT_FOUND_ARGUMENT;
  with labels_in_series do
  begin
    found_label_number:=false;
    i:=0;
    while not found_label_number and (i<labels_amount) do
      with labels_in_text[i] do
        if Label_name=possible_label_name then
        begin
          found_label_number:=true;
          number_found_label:=label_number_next_operator;
        end
        else
          inc(i);
  end;
  result:=number_found_label;
end;

function found_position_jump_on_label(const working_text:string;
 var operator_information:Toperator_information):integer;
var
  possible_label_name:string;
  number_found_label:integer;
begin
  possible_label_name:=search_possible_label_name(working_text,operator_information);
  number_found_label:=search_label_by_name(possible_label_name);
  result:=number_found_label;
end;

procedure add_uncoditional_jump(const current_operator_number:integer;
 const working_text:string);
var
  number_label_for_current_jump:integer;
begin
  with operators_in_series.operators_in_text[current_operator_number] do
  begin
    number_label_for_current_jump:=found_position_jump_on_label(working_text,
     operator_information);

    if number_label_for_current_jump<>CODE_NOT_FOUND_ARGUMENT then
      with number_next_operator do
        if number_label_for_current_jump<>what_next_operator_can_go[next_operator_amount-1] then
          what_next_operator_can_go[next_operator_amount-1]:=number_label_for_current_jump;
  end;
end;

procedure add_conditional_jump(const current_operator_number:integer;
 const working_text:string);
var
  number_label_for_current_jump:integer;
begin
  with operators_in_series.operators_in_text[current_operator_number] do
  begin
    number_label_for_current_jump:=found_position_jump_on_label(working_text,
     operator_information);

    if number_label_for_current_jump<>CODE_NOT_FOUND_ARGUMENT then
      with number_next_operator do
        if number_label_for_current_jump<>what_next_operator_can_go[next_operator_amount-1] then
        begin
          inc(next_operator_amount);
          setlength(what_next_operator_can_go,next_operator_amount);
          what_next_operator_can_go[next_operator_amount-1]:=number_label_for_current_jump;
        end;
  end;
end;

procedure add_operators_new_way(const current_operator_number:integer;
 const working_text:string);
begin
  with operators_in_series.operators_in_text[current_operator_number].operator_information do
    case operator_position_in_array_table of
      Position_unconditional_jump:
        add_uncoditional_jump(current_operator_number,working_text);
    else
      add_conditional_jump(current_operator_number,working_text);
    end;
end;


procedure search_all_jump(const working_text:string);
var
  i:integer;
begin
  with operators_in_series do
    for i:=0 to operators_amount-1 do
      with operators_in_text[i].operator_information do
        if operator_position_in_array_table in [START_OPERATORS_JUMP..END_OPERATORS_JUMP] then
          add_operators_new_way(i,working_text);
end;


procedure delete_in_all_ret_next_number;
var
  i:integer;
begin
  with operators_in_series do
    for i:=0 to operators_amount-1 do
      with operators_in_text[i] do
        if operator_information.operator_position_in_array_table=POSITION_OPERATOR_RET then
          with number_next_operator do
          begin
            next_operator_amount:=0;
            setlength(what_next_operator_can_go,next_operator_amount);
          end;
end;

procedure clear_stack_number(var some_stack:TStack_operator_number);
begin
  with some_stack do
  begin
    stack_amount:=0;
    setlength(stack_data,stack_amount);
  end;
end;

procedure add_stack_number(var some_stack:TStack_operator_number;const new_data:integer);
begin
  with some_stack do
  begin
    inc(stack_amount);
    setlength(stack_data,stack_amount);
    stack_data[stack_amount-1]:=new_data;
  end;
end;

procedure return_stack_number(var some_stack:TStack_operator_number;var return_data:integer);
begin
  with some_stack do
    if stack_amount>0 then
    begin
      return_data:=stack_data[stack_amount-1];
      dec(stack_amount);
      setlength(stack_data,stack_amount);
    end
    else
      return_data:=CODE_NOT_FOUND_ARGUMENT;
end;


procedure clear_stack_state(var some_stack:TStack_operator_state);
begin
  with some_stack do
  begin
    stack_amount:=0;
    setlength(stack_data,stack_amount);
  end;
end;

procedure add_stack_state(var some_stack:TStack_operator_state;const new_data:TOperator_State);
begin
  with some_stack do
  begin
    inc(stack_amount);
    setlength(stack_data,stack_amount);
    stack_data[stack_amount-1]:=new_data;
  end;
end;

procedure return_stack_state(var some_stack:TStack_operator_state;var return_data:TOperator_State);
begin
  with some_stack do
    if stack_amount>0 then
    begin
      return_data:=stack_data[stack_amount-1];
      dec(stack_amount);
      setlength(stack_data,stack_amount);
    end
    else
      return_data:=not_found;
end;


procedure add_next_number_in_stack(const current_operator_number:integer;
 const working_text:string;var current_operator_state:TOperator_state);
var
  number_label_for_current_jump:integer;
begin
  with operators_in_series.operators_in_text[current_operator_number] do
  begin
    number_label_for_current_jump:=found_position_jump_on_label(working_text,
     operator_information);
    if number_label_for_current_jump<>CODE_NOT_FOUND_ARGUMENT then
    with number_next_operator do
    begin
      add_stack_number(stack_operator_number,what_next_operator_can_go[next_operator_amount-1]);
      add_stack_state(stack_operator_state,current_operator_state);
      what_next_operator_can_go[next_operator_amount-1]:=number_label_for_current_jump;
      current_operator_state:=called_proc;
    end;
  end;
end;

procedure return_next_number_from_stack(const current_operator_number:integer;
 const working_text:string;var current_operator_state:TOperator_state);
var
  new_next_operator:integer;
begin
  with operators_in_series.operators_in_text[current_operator_number].number_next_operator do
  begin
    return_stack_number(stack_operator_number,new_next_operator);
    return_stack_state(stack_operator_state,current_operator_state);
    inc(next_operator_amount);
    setlength(what_next_operator_can_go,next_operator_amount);
    what_next_operator_can_go[next_operator_amount-1]:=new_next_operator;
  end;
end;

procedure step_for_all_operators(current_operator:integer;const working_text:string;
 var operator_visited:TDynamicBool);

const
  first_line_jump_visit=0;
var
  i:integer;
  current_operator_state:TOperator_state;
begin
  return_stack_state(stack_operator_state,current_operator_state);

  with operators_in_series do
  begin
    if (current_operator<operators_amount) and (current_operator_state<>not_found) then
      if (operator_visited[current_operator]<>visited) then
      begin
        if operator_visited[current_operator]<>called_proc then
          operator_visited[current_operator]:=current_operator_state;
        with operators_in_text[current_operator] do
          with operator_information do
          begin
            if (operator_visited[current_operator]<>called_proc) and
             (operator_position_in_array_table=POSITION_OPERATOR_CALL) then
            begin
              add_next_number_in_stack(current_operator,working_text,
               operator_visited[current_operator]);
              current_operator_state:=is_proc;
            end;

            with number_next_operator do
            begin
              if operator_visited[current_operator]=not_visited then
                operator_visited[current_operator]:=visited;

              if (operator_visited[current_operator]=is_proc) and
               (operator_position_in_array_table=POSITION_OPERATOR_RET) then
              begin
                return_next_number_from_stack(current_operator,working_text,current_operator_state);
                with stack_operator_state do
                  add_stack_state(stack_operator_state,current_operator_state);
                step_for_all_operators(what_next_operator_can_go[next_operator_amount-1],
                 working_text,operator_visited);
              end
              else
              begin
                for i:=0 to next_operator_amount-2 do
                  with stack_operator_number do
                    add_stack_number(stack_operator_number,stack_data[stack_amount-1]);

                for i:=0 to next_operator_amount-1 do
                begin
                  if i=first_line_jump_visit then
                  with stack_operator_state do
                    add_stack_state(stack_operator_state,current_operator_state)
                  else
                    add_stack_state(stack_operator_state,not_visited);
                  step_for_all_operators(what_next_operator_can_go[i],working_text,operator_visited);
                end;
              end;
            end;
          end;
      end;
  end;
end;

procedure set_stack_jumps(const working_text:string);
var
  operator_visited:TDynamicBool;
  i:integer;
begin
  delete_in_all_ret_next_number;

  clear_stack_number(stack_operator_number);
  clear_stack_state(stack_operator_state);

  with operators_in_series do
  begin
    add_stack_number(stack_operator_number,operators_amount);
    add_stack_state(stack_operator_state,not_visited);

    setlength(operator_visited,operators_amount);
    for i:=0 to operators_amount-1 do
      operator_visited[i]:=not_visited;
  end;

  step_for_all_operators(START_OPERATOR_NUMBER,working_text,operator_visited);
  clear_stack_state(stack_operator_state);
  clear_stack_number(stack_operator_number);
end;

end.
