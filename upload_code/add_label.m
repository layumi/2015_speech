function label_new = add_label( label,str )
%ADD_LABEL 此处显示有关此函数的摘要
%   此处显示详细说明
      if( ~isempty( strfind(str,'11') ) ) 
          label_new = [label,11];
      elseif( ~isempty( strfind(str,'12') ) ) 
          label_new = [label,12];
      elseif( ~isempty( strfind(str,'13') ) ) 
          label_new = [label,13];
      elseif( ~isempty( strfind(str,'14') ) ) 
          label_new = [label,14];
      elseif( ~isempty( strfind(str,'15') ) ) 
          label_new = [label,15];
      elseif( ~isempty( strfind(str,'16') ) ) 
          label_new = [label,16];
      elseif( ~isempty( strfind(str,'17') ) ) 
          label_new = [label,17];
      elseif( ~isempty( strfind(str,'18') ) ) 
          label_new = [label,18];
      elseif( ~isempty( strfind(str,'19') ) ) 
          label_new = [label,19];
      elseif( ~isempty( strfind(str,'20') ) ) 
          label_new = [label,20];
      elseif( ~isempty( strfind(str,'10') ) ) 
          label_new = [label,10];
      elseif( ~isempty( strfind(str,'2') ) ) 
          label_new = [label,2];
      elseif( ~isempty( strfind(str,'3') ) ) 
          label_new = [label,3];
      elseif( ~isempty( strfind(str,'4') ) ) 
          label_new = [label,4];
      elseif( ~isempty( strfind(str,'5') ) ) 
          label_new = [label,5];
      elseif( ~isempty( strfind(str,'6') ) ) 
          label_new = [label,6];
      elseif( ~isempty( strfind(str,'7') ) ) 
          label_new = [label,7];
      elseif( ~isempty( strfind(str,'8') ) ) 
          label_new = [label,8];
      elseif( ~isempty( strfind(str,'9') ) ) 
          label_new = [label,9];
      elseif( ~isempty( strfind(str,'1') ) ) 
          label_new = [label,1];
      else
          disp('filename error');
      end
end

