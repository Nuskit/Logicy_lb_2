unit UConstant;

interface

type
  Toperator_information=record
    operator_position:integer;
    operator_position_in_array_table:integer;
  end;

  TNumber_next_operator=record
    next_operator_amount:integer;
    what_next_operator_can_go:array of integer;
  end;

  Toperators_in_text=record
    operator_information:Toperator_information;
    number_next_operator:Tnumber_next_operator;
  end;

  TOperators_in_series=record
    operators_amount:integer;
    operators_in_text:array of TOperators_in_text;
  end;

  TLabels_in_text=record
    Label_name:string;
    Label_number_next_operator:integer;
  end;

  TLabels_in_series=record
    labels_amount:integer;
    labels_in_text:array of TLabels_in_text;
  end;

const
  ARRAY_OPERATORS_JUMP_LEN=36;
  ARRAY_OPERATORS_WITHOUT_JUMP_LEN=68;

  ARRAY_OPERATORS_ALL_LEN=ARRAY_OPERATORS_JUMP_LEN+ARRAY_OPERATORS_WITHOUT_JUMP_LEN;

  START_OPERATORS_JUMP=0;
  END_OPERATORS_JUMP=ARRAY_OPERATORS_JUMP_LEN-1;
  START_OPERATORS_WITHOUT_JUMP=ARRAY_OPERATORS_JUMP_LEN;
  END_OPERATORS_WITHOUT_JUMP=ARRAY_OPERATORS_WITHOUT_JUMP_LEN-1;
const

  {first operators_jump,then operators_without_jump}
  Operators_all:array [0.. ARRAY_OPERATORS_ALL_LEN-1]of string=
    ('jmp','jz','je','jnz','jnr','jc','jnae','jb','jnc','jle','jnb','jp','jnp',
    'js','jns','jo','jno','ja','jnbe','jna','jbe','jg','jnle','jge','jnl','jl',
    'jnhr','jlr','jng','jcxz','jecxz','loop','loope','loopne','loopz','loopnz',

    'call','ret','add','and','clc','std','cmp','cmps','cmpsb','cmpsw',
    'cmpsd','mov','cmpxchg','dec','div','idiv','imul','in','inc','int','lahf',
    'movs','movsb','movsw','movsd','movsx','movzx','mul','neg','nop','not',
    'or','out','pop','popf','push','pushf','rcl','rcr','rep','repe','repz',
    'repne','repnz','retf','rol','ror','sahf','sal','sar','scas','scasb',
    'scasw','scasd','shl','shr','stc','std','stos','stosb','stosw','stosd',
    'sub','test','xchg','xlat','xor','invoke');

const
  POSITION_UNCONDITIONAL_JUMP=0;

//These operators work with the stack
  POSITION_OPERATOR_CALL=START_OPERATORS_WITHOUT_JUMP;
  POSITION_OPERATOR_RET=POSITION_OPERATOR_CALL+1;


  CODE_GO_TO_THE_NEXT_LINE=#13#10;
  START_OPERATOR_NUMBER=0;

implementation

end.
