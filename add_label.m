function label_new = add_label( label,str )
%ADD_LABEL 此处显示有关此函数的摘要
%   此处显示详细说明
      if( ~isempty( strfind(str,'beijing') ) ) 
          label_new = [label,1];
      elseif( ~isempty( strfind(str,'close') ) ) 
          label_new = [label,2];
      elseif( ~isempty( strfind(str,'computer') ) ) 
          label_new = [label,3];
      elseif( ~isempty( strfind(str,'dakai') ) ) 
          label_new = [label,4];
      elseif( ~isempty( strfind(str,'delete') ) ) 
          label_new = [label,5];
      elseif( ~isempty( strfind(str,'file') ) ) 
          label_new = [label,6];
      elseif( ~isempty( strfind(str,'guanbi') ) ) 
          label_new = [label,7];
      elseif( ~isempty( strfind(str,'hebei') ) ) 
          label_new = [label,8];
      elseif( ~isempty( strfind(str,'henan') ) ) 
          label_new = [label,9];
      elseif( ~isempty( strfind(str,'image') ) ) 
          label_new = [label,10];
      elseif( ~isempty( strfind(str,'jisuanji') ) ) 
          label_new = [label,11];
      elseif( ~isempty( strfind(str,'open') ) ) 
          label_new = [label,12];
      elseif( ~isempty( strfind(str,'shanchu') ) ) 
          label_new = [label,13];
      elseif( ~isempty( strfind(str,'shanghai') ) ) 
          label_new = [label,14];
      elseif( ~isempty( strfind(str,'signal') ) ) 
          label_new = [label,15];
      elseif( ~isempty( strfind(str,'speech') ) ) 
          label_new = [label,16];
      elseif( ~isempty( strfind(str,'tuxiang') ) ) 
          label_new = [label,17];
      elseif( ~isempty( strfind(str,'wenjian') ) ) 
          label_new = [label,18];
      elseif( ~isempty( strfind(str,'xinhao') ) ||...
             ~isempty( strfind(str,'xinghao') ) ) 
          label_new = [label,19];
      elseif( ~isempty( strfind(str,'yuyin') ) ) 
          label_new = [label,20];
      else
          disp('filename error');
      end
end

