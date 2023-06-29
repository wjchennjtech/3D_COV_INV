function varargout = Variogram_caculation(varargin)
% VARIOGRAM_CACULATION MATLAB code for Variogram_caculation.fig
%      VARIOGRAM_CACULATION, by itself, creates a new VARIOGRAM_CACULATION or raises the existing
%      singleton*.
%
%      H = VARIOGRAM_CACULATION returns the handle to a new VARIOGRAM_CACULATION or the handle to
%      the existing singleton*.
%
%      VARIOGRAM_CACULATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VARIOGRAM_CACULATION.M with the given input arguments.
%
%      VARIOGRAM_CACULATION('Property','Value',...) creates a new VARIOGRAM_CACULATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Variogram_caculation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Variogram_caculation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help Variogram_caculation

% Last Modified by GUIDE v2.5 29-Mar-2023 20:25:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Variogram_caculation_OpeningFcn, ...
    'gui_OutputFcn',  @Variogram_caculation_OutputFcn, ...
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


% --- Executes just before Variogram_caculation is made visible.
function Variogram_caculation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Variogram_caculation (see VARARGIN)

% Choose default command line output for Variogram_caculation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Variogram_caculation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Variogram_caculation_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
wh=waitbar(0,'calculation...');
a = get(handles.uitable1,'data');
x=a(:,1);
y=a(:,2);
z=a(:,3);
val=a(:,4);
ga1 = get(handles.edit1,'string');
ga2 = get(handles.edit2,'string');
ga3 = get(handles.edit3,'string');
ga4 = get(handles.edit4,'string');
ga5 = get(handles.edit5,'string');
lag_distance = str2double(ga1);%最大距离,需要提前估算出来
n_lag= str2double(ga2);%滞后距的个数
lag_tolerance=str2double(get(handles.edit20,'string'));
azimuth = str2double(ga3); % 与东方向的夹角
elevation= str2double(ga4);% 倾角,beta=90为z轴方向
tolerance= str2double(ga5);% theta为容许角/容差角
D = [];
[h,gamma] = variogram3D(x,y,z,val,lag_distance,n_lag,lag_tolerance,azimuth,elevation,tolerance);
D(:,1)=h';
D(:,2)=gamma';
set(handles.uitable3,'Data',D);
close(wh);
toc
t=toc;
t
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(Variogram_caculation,'visible','off')

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
D = get(handles.uitable3,'data');
[filename_out,pathname_out]=uiputfile('*.txt','输入文件名');
fileout=fullfile(pathname_out,filename_out);
[l,w]=size(D);
K = reshape(D',1,l*w);
fid=fopen(fileout,'wt');
fprintf(fid,'%f\t%f\t\n',K);
fclose(fid);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable3,'Data','')

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_f_handle=figure('visible','off');
new_axes = copyobj(handles.axes1,new_f_handle); %picture是GUI界面绘图的坐标系句柄
[filename,pathname,fileindex]=uiputfile({'*.png';'*.bmp'},'save picture as');
if ~filename
    return
else
    file=strcat(pathname,filename);
    switch fileindex %根据不同的选择保存为不同的类型
        case 1
            print(new_f_handle,'-djpeg',file);
        case 2
            print(new_f_handle,'-dbmp',file);
    end
end
delete(new_f_handle);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla reset


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
a = get(handles.uitable3,'data');
vvv = max(a(:,2));
scatter(a(:,1),a(:,2))
axis([0 max(a(:,1))+0.1*max(a(:,1)) 0 vvv])
xlabel('Lag distance (m)')
ylabel('Gamma (kg/m^3)^2')
grid on
hold on

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rv1
global rv2
global vag1
% axes(handles.axes1)

a1 = get(handles.uitable3,'data');
h=a1(:,1);
gammaexp=a1(:,2);
for i=1:length(h)
    if h(i,1)>=rv2
       gammaexp(i,1)=rv1;
    end
end
if vag1 == 4
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','pentaspherical','nugget',0,'plotit',true);
elseif vag1 == 1
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','blinear','nugget',0,'plotit',true);
elseif vag1 == 2
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','circular','nugget',0,'plotit',true);
elseif vag1 == 3
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','spherical','nugget',0,'plotit',true);
elseif vag1 == 4
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','pentaspherical','nugget',0,'plotit',true);
elseif vag1 == 5
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','exponential','nugget',0,'plotit',true);
elseif vag1 == 6
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','gaussian','nugget',0,'plotit',true);
elseif vag1 == 7
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','whittle','nugget',0,'plotit',true);
elseif vag1 == 8
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','stable','nugget',0,'plotit',true);
else
    [a,c,n] = variogramfitxx(h,gammaexp,rv2,rv1,[],'solver','fminsearchbnd','model','matern','nugget',0,'plotit',true);
end
hold on
grid on
a = num2str(a);
c = num2str(c);
n = num2str(n);
set(handles.edit12,'string',a)
set(handles.edit11,'string',c)
set(handles.edit13,'string',n)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SA
[filename,pathname] = uigetfile('*.*');
file = fullfile(pathname,filename);
SA = importdata(file);
set(handles.uitable1,'Data',SA);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable1,'Data','')


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles    structure with handles and user data (see GUIDATA)



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function axesdd_Callback(hObject, eventdata, handles)
% hObject    handle to axesdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(Variogram_fit,'visible','on')


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_file_Callback(hObject, eventdata, handles)
% hObject    handle to open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global KL
[filename,pathname]=uigetfile('*.*');
file=fullfile(pathname,filename);
KL=importdata(file);
set(handles.uitable3,'Data',KL);

% --------------------------------------------------------------------
function new_file_Callback(hObject, eventdata, handles)
% hObject    handle to new_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename_out,pathname_out]=uiputfile('*.txt','输入文件名');
fileout=fullfile(pathname_out,filename_out);
fid=fopen(fileout,'wt');
fclose(fid);

% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('确定退出?', ...
    '退出', ...
    '是','否','否');
switch choice
    case '是'
        close;
    otherwise
        return;
end

% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'string','');
set(handles.edit2,'string','');
set(handles.edit3,'string','');
set(handles.edit4,'string','');
set(handles.edit5,'string','');
set(handles.edit11,'string','');
set(handles.edit12,'string','');
set(handles.edit13,'string','');
set(handles.edit20,'string','');

% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
te1 = get(handles.edit1,'string');
te2 = get(handles.edit2,'string');
te3 = get(handles.edit3,'string');
te4 = get(handles.edit5,'string');
te5 = get(handles.edit4,'string');
te6 = get(handles.edit11,'string');
te7 = get(handles.edit13,'string');
te8 = get(handles.edit12,'string');
te1 = str2double(te1);
te2 = str2double(te2);
te3 = str2double(te3);
te4 = str2double(te4);
te5 = str2double(te5);
te6 = str2double(te6);
te7 = str2double(te7);
te8 = str2double(te8);
c = [];
c(1,1) = te1;
c(1,2) = te2;
c(2,1) = te3;
c(2,2) = te4;
c(3,1) = te5;
c(4,1) = te6;
c(4,2) = te7;
c(5,1) = te8;
c(3,2) = NaN;
c(5,2) = NaN;
[filename_out,pathname_out]=uiputfile('*.txt','输入文件名');
fileout=fullfile(pathname_out,filename_out);
[l,w]=size(c);
K = reshape(c',1,l*w);
fid=fopen(fileout,'wt');
fprintf(fid,'%f\t%f\t\n',K);
fclose(fid);


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(jdsm,'visible','on')


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(wx2,'visible','on')


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.*');
file = fullfile(pathname,filename);
SA = importdata(file);
set(handles.uitable3,'Data',SA);



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
