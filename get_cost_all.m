function cost=get_cost_all(true_label_vec, pre_label_vec,C_GG,C_GI,C_IG,C_II,impostClass)

  
Scost=0;
    for i=1:size(true_label_vec,2)
         true_label=true_label_vec(i);
         pre_label=pre_label_vec(i);
         if true_label==pre_label
             cost=0;
         else
             if ismember(true_label,impostClass)==0 && ismember(pre_label,impostClass)==0
                 cost=C_GG;
             else
                 if ismember(true_label,impostClass)==0 && ismember(pre_label,impostClass)==1
                     cost=C_GI;
                 else
                     if ismember(true_label,impostClass)==1 && ismember(pre_label,impostClass)==0
                         cost=C_IG;
                     else
                         cost=C_II;
                     end
                 end
             end
         end    
         Scost=Scost+cost;
    end
    cost=Scost;