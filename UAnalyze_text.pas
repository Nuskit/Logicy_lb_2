unit UAnalyze_text;

interface
uses
  UConstant;

  procedure Analyze_text(const plaintext:string);

var
  Operators_in_series:TOperators_in_series;
  Labels_in_series:TLabels_in_series;

implementation

uses
  UMain,UChain_operator,SysUtils;

type
  Toperator_has_in_text=array[START_OPERATORS_JUMP..ARRAY_OPERATORS_ALL_LEN-1] of boolean;

function search_operator(const number_operator:integer;
 working_text:string):integer;
var
  position_operator_in_start_text,position_operator_in_working_text:integer;
  len_operator:integer;
begin
  position_operator_in_start_text:=0;
  len_operator:=length(operators_all[number_operator]);
  with FMain do
  repeat
    position_operator_in_working_text:=pos(operators_all[number_operator],working_text);
    if (position_operator_in_working_text<>0) and (
     (position_operator_in_working_text>1)  and
     (working_text[position_operator_in_working_text-1]<>Code_Space) ) or ( (
     (position_operator_in_working_text+len_operator<=length(working_text)) and
     (working_text[position_operator_in_working_text+len_operator]<>Code_Space)))
      then
    begin
      delete(working_text,1,position_operator_in_working_text+len_operator-1);
      position_operator_in_start_text:=position_operator_in_start_text+
       position_operator_in_working_text;
      position_operator_in_working_text:=-1;
    end;
  until position_operator_in_working_text>=0;

  if position_operator_in_working_text=0 then
    position_operator_in_start_text:=0
  else
    position_operator_in_start_text:=position_operator_in_start_text+
     position_operator_in_working_text;
  result:=position_operator_in_start_text;
end;


function first_founding_operator_in_text(var operator_has_in_text:Toperator_has_in_text;
 const working_text:string;const start_operator,end_operator:integer):
 TOperator_information;
var
  i:integer;
  position_current_operator:integer;
  first_operator:TOperator_information;
begin
  first_operator.operator_position:=0;
  for i:=start_operator to end_operator do
    if operator_has_in_text[i] then
    begin
      position_current_operator:=search_operator(i,working_text);
      if position_current_operator=0 then
        operator_has_in_text[i]:=false
      else
        if (first_operator.operator_position=0) or (first_operator.operator_position>
         position_current_operator) then
        begin
          first_operator.operator_position:=position_current_operator;
          first_operator.operator_position_in_array_table:=i;
        end;
    end;
  result:=first_operator;
end;


procedure search_all_operators(working_text:string);
var
  operator_has_in_text:Toperator_has_in_text;
  i,last_position_operator:integer;
  len_operator:integer;
  found_all_operators:boolean;
begin
  for i:=START_OPERATORS_JUMP to ARRAY_OPERATORS_ALL_LEN-1 do
    operator_has_in_text[i]:=true;

  last_position_operator:=0;
  found_all_operators:=false;
  while Not found_all_operators do
    with operators_in_series do
    begin
      inc(operators_amount);
      setlength(operators_in_text,operators_amount);
      with operators_in_text[operators_amount-1] do
      begin
        with number_next_operator do
        begin
          next_operator_amount:=1;
          setlength(what_next_operator_can_go,next_operator_amount);
          what_next_operator_can_go[next_operator_amount-1]:=operators_amount;
        end;

        operator_information:=first_founding_operator_in_text(operator_has_in_text,
         working_text,START_OPERATORS_JUMP,ARRAY_OPERATORS_ALL_LEN-1);
        if operator_information.operator_position=0 then
        begin
          found_all_operators:=true;
          dec(operators_amount);
          setlength(operators_in_text,operators_amount);
        end
        else
          with operator_information do
          begin
            len_operator:=length(operators_all[operator_position_in_array_table]);
            delete(working_text,1,operator_position+len_operator-1);
            operator_position:=operator_position+last_position_operator;
            last_position_operator:=operator_position+len_operator-1;
          end;
      end;
    end;

end;

function search_position_first_label(const working_text:string;
 var Labels_current_name:string):integer;
const
  Symbol_Label_end=':';
var
  position_label_end,position_label_start,position_label_end_symvol:integer;
begin
  position_label_end_symvol:=pos(Symbol_Label_end,working_text);
  if position_label_end_symvol<>0 then
  begin
    position_label_end:=position_label_end_symvol;
    dec(position_label_end);
    while (position_label_end>0) and (working_text[position_label_end]=Code_space) do
      dec(position_label_end);

    position_label_start:=position_label_end;
    while (position_label_start>0) and (working_text[position_label_start]<>Code_space) do
      dec(position_label_start);

    Labels_current_name:=copy(working_text,position_label_start+1,
     position_label_end-position_label_start);
  end;
  result:=position_label_end_symvol;
end;


procedure search_label_number_next_operation(var position_label:integer;
 var Label_number_next_operator:integer);
var
  last_number_operator:integer;
begin
  with operators_in_series do
  begin
    last_number_operator:=operators_amount-1;
    while (last_number_operator>=0) and (position_label<
     operators_in_text[last_number_operator].operator_information.operator_position) do
      dec(last_number_operator);
    label_number_next_operator:=last_number_operator+1;
  end;
end;


procedure search_all_labels(working_text:string);
var
  position_first_label,last_position_label:integer;
  found_all_labels:boolean;
begin
  last_position_label:=0;
  found_all_labels:=false;
  while not found_all_labels do
    with labels_in_series do
    begin
      inc(labels_amount);
      setlength(labels_in_text,labels_amount);
      with labels_in_text[labels_amount-1] do
      begin
        position_first_label:=search_position_first_label(working_text,label_name);
        if position_first_label=0 then
        begin
          found_all_labels:=true;
          dec(labels_amount);
          setlength(labels_in_text,labels_amount);
        end
        else
          begin
            delete(working_text,1,position_first_label);
            last_position_label:=last_position_label+position_first_label;
            search_label_number_next_operation(last_position_label,
             Label_number_next_operator);
          end;
      end;
    end;

end;

procedure clear_operators_series(var Operators_in_series:Toperators_in_series);
begin
  with operators_in_series do
  begin
    operators_amount:=0;
    setlength(operators_in_text,operators_amount);
  end;
end;

procedure clear_labels_series(var labels_in_series:Tlabels_in_series);
begin
  with labels_in_series do
  begin
    labels_amount:=0;
    setlength(labels_in_text,labels_amount);
  end;
end;

procedure print_information_about_metric;
var
  i,j:integer;
  Result_text:string;
begin
  Result_text:='All_operators:  '+CODE_GO_TO_THE_NEXT_LINE;

  with operators_in_series do
  begin
    for i:=0 to operators_amount-1 do
      Result_text:=Result_text+inttostr(i)+') '+
       operators_all[operators_in_text[i].operator_information.operator_position_in_array_table]
       +CODE_GO_TO_THE_NEXT_LINE;
  end;

  Result_text:=Result_text+'All ways can go operator: '+CODE_GO_TO_THE_NEXT_LINE;;

  with operators_in_series do
    for i:=0 to operators_amount-1 do
    begin
      Result_text:=Result_text+inttostr(i)+') ';
      with operators_in_text[i].number_next_operator do
        for j:=0 to next_operator_amount-1 do
          Result_text:=Result_text+inttostr(what_next_operator_can_go[j])+' ';
      Result_text:=Result_text+CODE_GO_TO_THE_NEXT_LINE;
    end;

  FMain.Memo_rezult.text:=result_text;
end;

procedure calculate_metric;
var
  visited_operator:array of boolean;
  i,metric_rezult:integer;
  procedure walk_operators(operator_position:integer);
  var
    i:integer;
  begin
    if operator_position<>operators_in_series.operators_amount then
      if visited_operator[operator_position] then
        inc(metric_rezult)
      else
      begin
        visited_operator[operator_position]:=true;
        with operators_in_series.operators_in_text[operator_position].number_next_operator do
        for i:=0 to next_operator_amount-1 do
          walk_operators(what_next_operator_can_go[i]);
    end;
  end;

begin
  metric_rezult:=0;
  setlength(visited_operator,operators_in_series.operators_amount);
  for i:=0 to operators_in_series.operators_amount-1 do
    visited_operator[i]:=false;
  walk_operators(START_OPERATOR_NUMBER);
  FMain.Metric_Result.Caption:='Metric_Result: '+IntToStr(metric_rezult);
end;

procedure Analyze_text(const plaintext:string);
begin
  clear_operators_series(operators_in_series);

  clear_labels_series(labels_in_series);


  search_all_operators(plaintext);
  search_all_labels(plaintext);
  search_all_jump(plaintext);
  set_stack_jumps(plaintext);

  print_information_about_metric;

  calculate_metric;

  clear_operators_series(operators_in_series);

  clear_labels_series(labels_in_series);
end;

end.
