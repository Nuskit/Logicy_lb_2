unit Uwork_with_text;

interface

procedure Prepare_plaintext(var plaintext:string);

implementation

uses UMain,SysUtils;

const
  Symbol_comment_comment=';';
  Code_tab=#9;
  Code_space=#32;
  Empty_line='';


procedure delete_comments(var current_line:string);
  var
    position_start_comment:integer;
    len_line:integer;
begin
   position_start_comment:=pos(Symbol_comment_comment,current_line);
   if position_start_comment<>0 then
   begin
     len_line:=length(current_line);
     delete(current_line,position_start_comment,len_line-position_start_comment+1);
   end;
end;

procedure change_tab_on_space(var current_line:string);
var
  position_tab:integer;
begin
  repeat
    position_tab:=pos(Code_tab,current_line);
    if position_tab<>0 then
      current_line[position_tab]:=Code_space;
  until position_tab=0;
end;

{leaving one space between words in line}
procedure delete_some_space(var current_line:string;
   const start_position_space:integer;var len_line:integer);
var
  amount_space_for_delete,current_position:integer;
  last_space:boolean;
begin
  amount_space_for_delete:=0;
  last_space:=false;
  current_position:=start_position_space;
  repeat
    inc(current_position);
    if current_line[current_position]=Code_space then
      inc(amount_space_for_delete)
    else
      last_space:=true;
  until last_space or (current_position>len_line);
  delete(current_line,start_position_space+1,amount_space_for_delete);
  len_line:=len_line-amount_space_for_delete;
end;

procedure delete_over_space(var current_line:string);
  var
    len_line,current_position:integer;
begin
  len_line:=length(current_line);
  current_position:=1;
  while current_position<=len_line do
  begin
    if current_line[current_position]=Code_space then
      delete_some_space(current_line,current_position,len_line);
    inc(current_position);
  end;
end;

procedure delete_space(var current_line:string);
begin
  change_tab_on_space(current_line);
  delete_over_space(current_line);
end;

procedure delete_found_literals(var current_line:string;const code_Symbol_comment:char);
var
  current_position,current_line_len,position_delete_start,
   position_delete_end:integer;

  procedure found_code_Symbol_comment(var current_position,end_position:integer);
  begin
    while (current_position<=end_position) and (current_line[current_position]<>
     code_Symbol_comment) do
      inc(current_position);
  end;

begin
  current_position:=1;
  repeat
    current_line_len:=length(current_line);
    found_code_Symbol_comment(current_position,current_line_len);
    if current_position+1<=current_line_len then
    begin
      inc(current_position);
      position_delete_start:=current_position;
      found_code_Symbol_comment(current_position,current_line_len);
      position_delete_end:=current_position-1;

      delete(current_line,position_delete_start,
       position_delete_end-position_delete_start+1);
      current_position:=position_delete_start+1;
    end;
  until current_position>current_line_len;
end;

procedure delete_literals(var current_line:string);
const
  number_literals_symbol=2;
  symbol_literals:array[0..number_literals_symbol-1] of char=('''','"');
var
  i:integer;
begin
  for i:=low(symbol_literals) to high(symbol_literals) do
    delete_found_literals(current_line,symbol_literals[i]);
end;

procedure recorrect_line(var current_line:string);
begin
  delete_comments(current_line);
  delete_space(current_line);
  delete_literals(current_line);
end;

procedure prepare_plaintext(var plaintext:string);
  var
    number_line:integer;
    i:integer;
    current_line:string;
begin
  number_line:=FMain.Memo_plaintext.Lines.Count;
  for i:=0 to number_line-1 do
  begin
    current_line:=FMain.Memo_plaintext.Lines[i];

    recorrect_line(current_line);
    if current_line<>Empty_line then
      plaintext:=plaintext+current_line+Code_space;
  end;
  plaintext:=lowercase(plaintext);
end;
                                          
end.
