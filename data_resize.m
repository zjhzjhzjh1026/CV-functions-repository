%% section1 primary % feret
clear
close all
load c:\data\feret
new_data_m=[];
new_data_c=[];
for i=1:size(data_c,2)
    this_m=imresize(get_i_image(data_m,i,lie),[60,60]);
    new_data_m=[new_data_m this_m];
end
new_data_c=get_data_m2c_all(new_data_m, 60);
% figure(1);
% imshow(get_i_image(new_data_m,140,45));
% figure(2);
% imshow_c(new_data_c,45,140);
hang=60;lie=60;
max_dim=60;
data_m=new_data_m;
data_c=new_data_c;
save('c:\data\feret_new','data_m','data_c','data_label','hang','lie','num_each_person');

%% PIE: one person has 49 figures
clear
close all
load c:\data\Pose05_64x64

new_data_m=[];
new_data_c=[];
for i=1:size(gnd,1)
    this_m=imresize(get_data_c2m(fea(i,:)',64)',[60,60]);
    new_data_m=[new_data_m this_m];
end
new_data_c=get_data_m2c_all(new_data_m, 60);
% figure(1);
% imshow(get_i_image(new_data_m,140,45));
% figure(2);
% imshow_c(new_data_c,45,140);
hang=60;lie=60;
data_m=new_data_m;
data_c=new_data_c;
data_label=gnd';
num_each_person=49;
save('c:\data\Pose05_60x60new','data_m','data_c','data_label','hang','lie','num_each_person');
