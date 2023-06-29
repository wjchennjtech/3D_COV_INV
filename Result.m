function varargout = Result(varargin)
% RESULT MATLAB code for Result.fig
%      RESULT, by itself, creates a new RESULT or raises the existing
%      singleton*.
%
%      H = RESULT returns the handle to a new RESULT or the handle to
%      the existing singleton*.
%
%      RESULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULT.M with the given input arguments.
%
%      RESULT('Property','Value',...) creates a new RESULT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Result_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Result_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Result

% Last Modified by GUIDE v2.5 08-Mar-2023 11:28:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Result_OpeningFcn, ...
                   'gui_OutputFcn',  @Result_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Result is made visible.
function Result_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Result (see VARARGIN)

% Choose default command line output for Result
handles.output = hObject;
global xyzd;

set(handles.uitable2,'data',xyzd);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Result wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Result_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xyz;
global paramGrid;
global xyzd;
%观测格网
Obsgrid2D1D(:,1)=xyz(:,1);
Obsgrid2D1D(:,2)=xyz(:,2);
Obsgrid2D1D(:,3)=xyz(:,3);%观测高度
h=waitbar(0,'caculation...');
[ Matrix_gxx] = ForwardMatrix_gxx(Obsgrid2D1D, paramGrid);
[ Matrix_gxy] = ForwardMatrix_gxy(Obsgrid2D1D, paramGrid);
[ Matrix_gxz] = ForwardMatrix_gxz(Obsgrid2D1D, paramGrid);
[ Matrix_gyy] = ForwardMatrix_gyy(Obsgrid2D1D, paramGrid);
[ Matrix_gyz] = ForwardMatrix_gyz(Obsgrid2D1D, paramGrid);
[ Matrix_gzz] = ForwardMatrix_gzz(Obsgrid2D1D, paramGrid);
[ Matrix_gx] = ForwardMatrix_gx(Obsgrid2D1D, paramGrid);
[ Matrix_gy] = ForwardMatrix_gy(Obsgrid2D1D, paramGrid);
[ Matrix_gz] = ForwardMatrix_gz(Obsgrid2D1D, paramGrid);
density=xyzd(:,7);
gxx=Matrix_gxx*density;
gxy=Matrix_gxy*density;
gxz=Matrix_gxz*density;
gyy=Matrix_gyy*density;
gyz=Matrix_gyz*density;
gzz=Matrix_gzz*density;
gx=Matrix_gx*density;
gy=Matrix_gy*density;
gz=Matrix_gz*density;
data_all=Obsgrid2D1D;
data_all(:,4)=gxx;
data_all(:,5)=gxy;
data_all(:,6)=gxz;
data_all(:,7)=gyy;
data_all(:,8)=gyz;
data_all(:,9)=gzz;
data_all(:,10)=gx;
data_all(:,11)=gy;
data_all(:,12)=gz;
set(handles.uitable1,'data',data_all);
close(h)
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla reset
axis off

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_f_handle=figure('visible','off');
new_axes=copy(handles.axes1,new_f_handle); %picture是GUI界面绘图的坐标系句柄
set(new_axes,'units','default','Position','default');
cb=colorbar;
set(get(cb,'title'),'string','kg/m^3');
set(gca,'ZDir','reverse');
colormap(jet)
% xlabel('x-m');ylabel('y-m');zlabel('z-m');
[filename,pathname]=uiputfile({'*.png'},'save picture as');
if ~filename
    return
else
    file=strcat(pathname,filename);
    print(new_f_handle,'-djpeg',file);
end
delete(new_f_handle);
helpdlg('Save successfully!')

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.uitable2,'data');
[filename,pathname,c]=uiputfile('*.txt','Save the file to');
if c==1
    file=[pathname,filename];
    csvwrite(file,a);
    helpdlg('Save successfully!');
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable2,'data','');

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xyzd;
f=xyzd(:,7);
max_f=max(f);
min_f=min(f);
avg_f=mean(f);
s=std(f);
tdata=[min_f,max_f,avg_f,s];
set(handles.uitable3,'data',tdata)

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
global paramGrid;
global nx;
global ny;
global nz;
den=get(handles.uitable2,'data');
density=den(:,7);
slic=str2double(get(handles.edit1,'string'));
c =rot90(reshape(density,[nx,ny,nz]));
xmin = min(paramGrid(:,1));
xmax = max(paramGrid(:,1));
ymin = min(paramGrid(:,3));
ymax = max(paramGrid(:,3));
zmin = min(paramGrid(:,5));
zmax = max(paramGrid(:,5));
dx=paramGrid(1,2)-paramGrid(1,1);
dy=paramGrid(1,4)-paramGrid(1,3);
dz=paramGrid(1,6)-paramGrid(1,5);
[X,Y,Z] = meshgrid(xmin:dx:xmax,ymin:dy:ymax,zmin:dz:zmax);
xslice = [slic];   
yslice = [];
zslice = [];
slice(X,Y,Z,c,xslice,yslice,zslice,'nearest');
xlim([xmin xmax]);
ylim([ymin ymax]);
zlim([zmin zmax]);
cb=colorbar;
set(get(cb,'title'),'string','kg/m^3');
set(gca,'ZDir','reverse');
colormap(jet)
xlabel('x-m');ylabel('y-m');zlabel('z-m');
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
global paramGrid;
global nx;
global ny;
global nz;
den=get(handles.uitable2,'data');
density=den(:,7);
slic=str2double(get(handles.edit1,'string'));
c =rot90(reshape(density,[nx,ny,nz]));
xmin = min(paramGrid(:,1));
xmax = max(paramGrid(:,1));
ymin = min(paramGrid(:,3));
ymax = max(paramGrid(:,3));
zmin = min(paramGrid(:,5));
zmax = max(paramGrid(:,5));
dx=paramGrid(1,2)-paramGrid(1,1);
dy=paramGrid(1,4)-paramGrid(1,3);
dz=paramGrid(1,6)-paramGrid(1,5);
[X,Y,Z] = meshgrid(xmin:dx:xmax,ymin:dy:ymax,zmin:dz:zmax);
xslice = [];   
yslice = [slic];
zslice = [];
slice(X,Y,Z,c,xslice,yslice,zslice,'nearest');
xlim([xmin xmax]);
ylim([ymin ymax]);
zlim([zmin zmax]);
colormap(jet)
cb=colorbar;
set(get(cb,'title'),'string','kg/m^3');
set(gca,'ZDir','reverse');
xlabel('x-m');ylabel('y-m');zlabel('z-m');
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
global paramGrid;
global nx;
global ny;
global nz;
den=get(handles.uitable2,'data');
density=den(:,7);
slic=str2double(get(handles.edit1,'string'));
c =rot90(reshape(density,[nx,ny,nz]));
xmin = min(paramGrid(:,1));
xmax = max(paramGrid(:,1));
ymin = min(paramGrid(:,3));
ymax = max(paramGrid(:,3));
zmin = min(paramGrid(:,5));
zmax = max(paramGrid(:,5));
dx=paramGrid(1,2)-paramGrid(1,1);
dy=paramGrid(1,4)-paramGrid(1,3);
dz=paramGrid(1,6)-paramGrid(1,5);
[X,Y,Z] = meshgrid(xmin:dx:xmax,ymin:dy:ymax,zmin:dz:zmax);
xslice = [];   
yslice = [];
zslice = [slic];
slice(X,Y,Z,c,xslice,yslice,zslice,'nearest');
xlim([xmin xmax]);
ylim([ymin ymax]);
zlim([zmin zmax]);
colormap(jet)
cb=colorbar;
set(get(cb,'title'),'string','kg/m^3');
set(gca,'ZDir','reverse');
xlabel('x-m');ylabel('y-m');zlabel('z-m');


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes2,new_f_handle); 
set(new_axes,'units','default','Position','default');
cb = colorbar;
g1=get(handles.radiobutton7,'value');
g2=get(handles.radiobutton8,'value');
g3=get(handles.radiobutton9,'value');
if g1==1||g2==1||g3==1
set(get(cb,'title'),'string','mGal');
else
    set(get(cb,'title'),'string','E');
end
colormap(jet)
[filename,pathname]=uiputfile({'*.png'},'save picture as');
if ~filename
    return
else
    file=strcat(pathname,filename);
    print(new_f_handle,'-djpeg',file);
end
delete(new_f_handle);
helpdlg('Save successfully!')

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla reset
axis off

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2)
data_all=get(handles.uitable1,'data');
rbgxx=get(handles.radiobutton1,'value');
rbgxy=get(handles.radiobutton2,'value');
rbgxz=get(handles.radiobutton3,'value');
rbgyy=get(handles.radiobutton4,'value');
rbgyz=get(handles.radiobutton5,'value');
rbgzz=get(handles.radiobutton6,'value');
rbgx=get(handles.radiobutton7,'value');
rbgy=get(handles.radiobutton8,'value');
rbgz=get(handles.radiobutton9,'value');
if rbgxx==1
    dobs=data_all(:,4)*10^9;
   elseif rbgxy==1
    dobs=data_all(:,5)*10^9;
    elseif rbgxz==1
    dobs=data_all(:,6)*10^9;
    elseif rbgyy==1
    dobs=data_all(:,7)*10^9;
    elseif rbgyz==1
    dobs=data_all(:,8)*10^9;
    elseif rbgzz==1
    dobs=data_all(:,9)*10^9;
    elseif rbgx==1
    dobs=data_all(:,10)*10^5;
    elseif rbgy==1
    dobs=data_all(:,11)*10^5;
    elseif rbgz==1
    dobs=data_all(:,12)*10^5;
end
minx = min(data_all(:,1));
maxx = max(data_all(:,1));
miny = min(data_all(:,2));
maxy = max(data_all(:,2));
nx =( max(data_all(:,1))-min(data_all(:,1)))/(max(data_all(2,1))-min(data_all(1,1)))+1;
ny = length(data_all(:,1))/nx;
dObscontour_dobs = onedtotwod( dobs,nx,ny );
imagesc(minx:3:maxx,miny:3:maxy,(dObscontour_dobs));
set(gca,'YDir','normal');
xlabel('X Distance');
ylabel('Y distance');
title('Predicted ');
colormap(jet)
cb=colorbar;
if rbgx==1||rbgy==1||rbgz==1
    set(get(cb,'title'),'string','mGal')
else
    set(get(cb,'title'),'string','E')
end

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
hold on;


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.uitable1,'data');
[filename,pathname,c]=uiputfile('*.txt','Save the file to');
if c==1
    file=[pathname,filename];
    csvwrite(file,a);
    helpdlg('Save successfully!');
end

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.uitable1,'data');
for i=4:12
f=a(:,i);    
max_f=max(f);
min_f=min(f);
avg_f=mean(f);
s=std(f);
tdata(i-3,:)=[min_f,max_f,avg_f,s];
end
set(handles.uitable5,'data',tdata)

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.uitable5,'data');
[filename,pathname,c]=uiputfile('*.txt','Save the file to');
if c==1
    file=[pathname,filename];
    csvwrite(file,a);
    helpdlg('Save successfully!');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.uitable3,'data');
[filename,pathname,c]=uiputfile('*.txt','Save the file to');
if c==1
    file=[pathname,filename];
    csvwrite(file,a);
    helpdlg('Save successfully!');
end
