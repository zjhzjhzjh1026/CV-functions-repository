function mean_cell = get_mean_image( train_data_c, train_label, P )   
   mean_cell=cell(2,P.num_person);
   %Ni=zeros(P.num_person,P.num_person);
   person_label= unique(train_label);   
   Ni_index=cell(1,P.num_person); 
   %mean_Ni=zeros(P.hang,P.lie*num_person);
  
   for i=1:P.num_person
       Ni_index{1,i}=find(train_label==person_label(i));
       Ni(i,i)=length(Ni_index{1,i});    
       this_mean_Ni_c=mean(train_data_c(:,Ni_index{1,i}),2);       
       mean_cell{1,i}=get_data_c2m(this_mean_Ni_c,P.lie);
       this_diff_vec=(train_data_c(:,Ni_index{1,i})-repmat(this_mean_Ni_c,1,Ni(i,i))).^2;
       this_norm2_vec=sum(this_diff_vec);
       this_var=var(this_norm2_vec);
       mean_cell{2,i}=this_var;
       mean_cell{3,i}=Ni(i,i);
   end

   
