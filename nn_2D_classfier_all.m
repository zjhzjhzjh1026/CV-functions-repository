function label=nn_2D_classfier_all(train_data, train_label, test_data)

[n,c]=size(train_data);
low_dim=c/size(train_label,2);% the number of columns of each image 
% nt_lie=size(test_data,2);
nt=size(test_data,2)/low_dim; %number of test images
label=zeros(1,nt);
num_object=size(train_label,2); %number of train images
  
for i=1:nt
%     i
%     nt
%     size(test_data(:,(i-1)*low_dim+1:i*low_dim))
x_m=repmat(test_data(:,(i-1)*low_dim+1:i*low_dim),1,num_object); 
if low_dim==1 && n==1 %---------new
    dist=(train_data-x_m).^2; %if the trainfeature of an image is a number
elseif low_dim==1 
    dist=sum((train_data-x_m).^2); %every image is a column vector
elseif n==1
     dist=sum(reshape((train_data-x_m).^2, low_dim, num_object)); %every image is a row vector
else
    diff2=sum((train_data-x_m).^2); %every image minus the i-th image, then square all the elements, sum by column
    dist=sum(reshape(diff2,low_dim, num_object));
    %b=reshape(a,hang,lie): b(:,1)=a(1:hang), reshape the matrix by column
end

[~, index]=min(dist);
label(i)=train_label(index);
end

% a=1:9
% diff2=sum((a-4.5).^2)
% a=3,b=1
% if a==1 && b==1
%     c=a+b
% elseif a==1
%     c=b+2
% elseif b==1
%     c=a+2
% else
%     c=0
% end