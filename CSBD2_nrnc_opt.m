function [nr, nc, minc_vector]=CSBD2_nrnc_opt( train_data_m, train_label, test_data_m, test_label, P ,aindex,CSV1,CStransV2)

[train_data_m_trans, test_data_m_trans]=get_train_test_trans( train_data_m, test_data_m,P);
% aindex=DindexCS<=lie;  %to matrix A, the dimension of Solving matrix is lie*lie
     PBD.num_train=P.num_train;
     PBD.num_test=P.num_test;
     PBD.cost_m=P.cost_m;         
    hang=P.hang;
    lie=P.lie;
   
    opt_dim=P.dim;
    aa=find(aindex~=aindex(1));
  if opt_dim < min(hang,lie)  %%%不是充分必要？？
      dividvector=1:opt_dim;
  else        
    a2=max(aa(1),ceil(opt_dim/(hang+lie)));
    dividvector=a2:hang+lie;%floor ceil round fix
  end
    
    provector=opt_dim*ones(size(dividvector));
    x= rem(provector,dividvector)==0;
    div_2vec=dividvector(x);
    provalue=zeros(5,size(div_2vec,2));

for i=1:size(div_2vec,2)  
    ni=div_2vec(i);
    nj=opt_dim/ni;
    dim_A=sum(aindex(1:ni));
    
    if dim_A > 0
         PBD.lie=lie;
         PBD.dim=dim_A;
         [train_feature001, test_feature001] = All2D_feature( train_data_m,test_data_m,CSV1,PBD);     %%对横方向投影进行特征提取
         PBD.lie=dim_A;
         [Btrain1CS, Btest1CS] = get_train_test_trans(train_feature001,test_feature001, PBD);
         CStrain1_feature_c=get_data_m2c_all(Btrain1CS, hang);
         [CSfeature1V2,aa,aa,aa,CSfeature1D2]=CS2DLDA_V(Btrain1CS, CStrain1_feature_c, train_label, PBD);
    else
         CSfeature1V2=[];  CSfeature1D2=[];  dim_A_alt=0;         
    end

    if ni - dim_A > 0
        PBD.lie=hang;
        PBD.dim=ni - dim_A;   
        [train_feature002, test_feature002] = All2D_feature( train_data_m_trans,test_data_m_trans,CStransV2,PBD);   %%如果ni-dim_A>0，即是纵方向有特征，则计算纵方向
        PBD.lie=ni-dim_A;
        [Btrain2CS, Btest2CS] = get_train_test_trans(train_feature002,test_feature002, PBD);
        CS2_feature_c=get_data_m2c_all(Btrain2CS, lie);
        [CSfeatureTV2,aa,aa,aa,CSfeatureTD2]=CS2DLDA_V(Btrain2CS, CS2_feature_c, train_label, PBD);
    else
         CSfeatureTV2=[];  CSfeatureTD2=[]; 
    end   
    
    if dim_A > 0                                       %%第二次投影开始
        EIGfeatureD=[CSfeature1D2;CSfeatureTD2];
        [EIGfeatureD_sort,Dindexfeature]=sort(EIGfeatureD,'descend');
        alt_index=Dindexfeature<=hang;     %to matrix B^T, the dimension of Solving matrix is: hang*hang   
        dim_A_alt=sum( alt_index(1:nj) );
    end
    
    if dim_A_alt > 0
         PBD.lie=hang;
         PBD.dim=dim_A_alt;
         [train_feature011, test_feature011] = All2D_feature( Btrain1CS,Btest1CS,CSfeature1V2,PBD);   %%对横方向图进行第二次代价敏感投影
    else
        train_feature011=[];  test_feature011=[];
    end
    
    if nj - dim_A_alt >0
         PBD.lie=lie;
         PBD.dim=nj-dim_A_alt;
         [train_feature021, test_feature021] = All2D_feature( Btrain2CS,Btest2CS,CSfeatureTV2,PBD);  %%对纵方向图进行第二次代价敏感投影
    else
        train_feature021=[];  test_feature021=[];
    end
         
    train_feature05tt=get_comb_mat(train_feature011,train_feature021,dim_A_alt,nj-dim_A_alt);    %%将得到的训练集合测试机合并
    test_feature05tt=get_comb_mat(test_feature011,test_feature021,dim_A_alt,nj-dim_A_alt);
   [err_IG6, err_GI6, err_GG6, err6, cost6,aa] =predict_result_2D(train_feature05tt, train_label, test_feature05tt, test_label, P);  %%求出表示识别效果的各项识别率
   
   provalue(:,i)= [err_IG6; err_GI6; err_GG6; err6; cost6];
   
end

    [aa,x_num]=min(provalue(5,:));
    minc_vector=provalue(:,x_num);
    nr=div_2vec(x_num);
    nc=opt_dim/nr;