function varargout = GUIV2(varargin)
% GUIV2 MATLAB code for GUIV2.fig
%      GUIV2, by itself, creates a new GUIV2 or raises the existing
%      singleton*.
%
%      H = GUIV2 returns the handle to a new GUIV2 or the handle to
%      the existing singleton*.
%
%      GUIV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIV2.M with the given input arguments.
%
%      GUIV2('Property','Value',...) creates a new GUIV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIV2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIV2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIV2

% Last Modified by GUIDE v2.5 31-Dec-2017 16:39:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIV2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIV2_OutputFcn, ...
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


% --- Executes just before GUIV2 is made visible.
function GUIV2_OpeningFcn(hObject, eventdata, handles, varargin)
global b
global mode
global dataBuffer
global threshold
global TaskTimer
global startT
startT = 0;
threshold = 60;
mode = 1;
dataBuffer = [];
 TaskTimer = timer;
 set(TaskTimer,'Name','autoRefreshText','TimerFcn',{@update,handles})
 set(TaskTimer,'ExecutionMode','fixedSpacing','Period',5)
 if exist('b')
     start(TaskTimer)
     startT = 1;
 end
 
% This function has no output args, see OutputFcn.
% hObject    handle to figure


% varargin   command line arguments to GUIV2 (see VARARGIN)

% Choose default command line output for GUIV2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using GUIV2.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes GUIV2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIV2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure



% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)


axes(handles.axes1);
cla;
plot(membrane)
%popup_sel_index = get(handles.popupmenu1, 'Value');
%switch popup_sel_index
%    case 1
%        plot(rand(5));
%    case 2
%        plot(sin(1:0.01:25.99));
%    case 3
%        bar(1:.5:10);
%    case 4
%        plot(membrane);
%    case 5
%        surf(peaks);
%end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)




% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)


file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)


printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)


selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)



% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
%end

%set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes during object creation, after setting all properties.




%================================main======================================

%----------------------------------------------global----------------------
global b
global threshold
global mode 
global dataBuffer
global dataT
global dataH
global dataX
global dataY
global TaskTimer
global startT

%----------------------------------------------function--------------------



%---------------------------update temperature and humidity from dataBuffer

function update(hObject, eventdata,handles)
global mode
global dataBuffer
global dataT
global dataH
global dataX
global dataY

if mode == 2
    update2(handles)
else
    update1(handles)
end

function update1(handles)
global dataBuffer
global dataT 
global dataH 
dataT = [];
dataH = [];
flushData();
dataBuffer
for i = 8 : 1 : length(dataBuffer)-1
    if dataBuffer(i) == ('h' + 0)
        dataH = [dataH , (dataBuffer(i + 1) + 0)];
        i = i + 1;
        continue
    end
    if dataBuffer(i) == (116 + 0)
        dataT = [dataT , (dataBuffer(i + 1) + 0)];
        i = i + 1;
        continue
    end
end
if length(dataH) >= 1
    if  length(dataH) ~= length(dataT)
        a = min([length(dataH),length(dataT)]);
        dataH = dataH(end - a + 1 : end)
        dataT = dataT(end - a + 1 : end)
    end
    refreshText(handles);
end


%------------------------update temperature, humidity, X, Y from dataBuffer
function update2(handles)
global dataBuffer
global dataT 
global dataH 
global dataX 
global dataY 
dataT = [];
dataH = [];
dataX = [];
dataY = [];
flushData();
dataBuffer
for i = 16 : 1 : length(dataBuffer)-1
    if dataBuffer(i) == (120 + 0)
        dataX = [dataX , (dataBuffer(i + 1) + 0)];
        i = i + 1;
        continue
    end
    if dataBuffer(i) == ('y' + 0)
        dataY = [dataY , (dataBuffer(i + 1) + 0)];
        i = i + 1;
        continue
    end
    if dataBuffer(i) == ('h' + 0)
        dataH = [dataH , (dataBuffer(i + 1) + 0)];
        i = i + 1;
        continue
    end
    if dataBuffer(i) == (116 + 0)
        dataT = [dataT , (dataBuffer(i + 1) + 0)];
        i = i + 1;
        continue
    end
end
if length(dataX) >= 1
    if  max([length(dataX),length(dataY),length(dataH),length(dataT)]) ~= min([length(dataX),length(dataY),length(dataH),length(dataT)])
        a = min([length(dataX),length(dataY),length(dataH),length(dataT)]);
        dataH = dataH(end - a + 1 : end)
        dataT = dataT(end - a + 1 : end)
        dataX = dataX(end - a + 1 : end)
        dataY = dataY(end - a + 1 : end)
    end
    refreshText(handles);
end

%-----------------------basic data refreshment from bluetooth to dataBuffer
function flushData()
global dataBuffer
global b
%ensure size < 512
while floor((get(b, 'BytesAvailable')-8)/4) > 0
    dataBuffer = [dataBuffer , fread(b,1,'int8')];
end

if length(dataBuffer) > 512
    dataBuffer = dataBuffer((end - 511) : end);
    dataBuffer
end

%---------------------------------------------------refreshment for textTag
function  refreshText(handles)
global mode
global threshold
global dataT
global dataH

text = '模式： ';
switch(mode)
    case 1
        text = strcat(text,'静止加湿');
    case 2
        text = strcat(text,'湿度扫描');
    case 3
        text = strcat(text,'湿度定点');
    case 4
        text = strcat(text,'手动');
end
text = strcat(text,'________');
text = strcat(text,'当前设定阈值： ');
text = strcat(text,num2str(threshold));
text1 = '';
text1 = strcat(text1,'温度：');

text1 = strcat(text1,num2str(dataT(end)));
text1 = strcat(text1,'________湿度：');

text1 = strcat(text1,num2str(dataH(end)));

set(handles.mainText,'String',{text,text1});



function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - c'sto be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



% --- Executes on button press in refreshGraph.
function refreshGraph_Callback(hObject, eventdata, handles)
% hObject    handle to refreshGraph (see GCBO)


global dataT

global dataH
global dataX
global dataY
global mode
global TaskTimer
global startT
if mode == 2
    if startT == 0
        start(TaskTimer);
        startT = 1;
    else
        axes(handles.axes1);
        cla;
        [x,y] = meshgrid(-128:1:127,-128:1:127);
        
        z = griddata(dataX,dataY,dataH,x,y,'v4');
        c = griddata(dataX,dataY,dataT,x,y,'v4');
        s = surf(x,y,z,c);
        s.EdgeColor = 'none';
        view([130,20]);
        colorbar;
    end
    
else 

    axes(handles.axes1);
	cla;
    plot(dataH);
    hold on;
    plot(dataT);
end


    
%membrane;
%axis off


%---connect bluetooth and default setting
function start_Callback(hObject, eventdata, handles)
global b
global TaskTimer
global startT
 set(handles.bluetoothText,'String','Connecting...')   
 b = Bluetooth('W1P',1)
 fopen(b);
 set(handles.bluetoothText,'String','Connected')
 if startT == 0
     start(TaskTimer)
 end
 %default setting
 

 



% --- Executes during object deletion, before destroying properties.
function axes1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)




% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)



% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in modepushbutton1.
function modepushbutton1_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
dataBuffer = [];
mode = 1;
mm=49;
a = 109;
fprintf(b,'%s','m1');


set(handles.locateBt,'Enable','off')
set(handles.thresholdBt,'Enable','off')
refreshText(handles);

% hObject    handle to modepushbutton1 (see GCBO)




% --- Executes on button press in modepushbutton2.
function modepushbutton2_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
global TaskTimer
global startT
dataBuffer = [];
mode = 2
mm=2;

stop(TaskTimer)
startT = 0;
a = 109;

fprintf(b,'%s','m2');

set(handles.locateBt,'Enable','on')
set(handles.thresholdBt,'Enable','off')
refreshText(handles)
% hObject    handle to modepushbutton2 (see GCBO)




% --- Executes on button press in modepushbutton3.
function modepushbutton3_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
dataBuffer = [];
mode = 3
mm=3;
a = 109;

fprintf(b,'%s','m3');

set(handles.locateBt,'Enable','off')
set(handles.thresholdBt,'Enable','on')
refreshText(handles)

% hObject    handle to modepushbutton3 (see GCBO)




% --- Executes on button press in modepushbutton4.
function modepushbutton4_Callback(hObject, eventdata, handles)
global b
global mode
mode = 1
mm=1;
a = 109;

fprintf(b,'%s','m1');

refreshText(handles)
% hObject    handle to modepushbutton4 (see GCBO)




% --- Executes on button press in Bt1.
function Bt1_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
if mode ~= 4
    dataBuffer = [];
end
mode = 4
mm=4;
a = 109;

fprintf(b,'%s','m4');

set(handles.locateBt,'Enable','off')
set(handles.thresholdBt,'Enable','off')
refreshText(handles)
% hObject    handle to Bt1 (see GCBO)




% --- Executes on button press in Bt5.
function Bt5_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
if mode ~= 4
    dataBuffer = [];
end
mode = 4
mm=8;
a = 109;

fprintf(b,'%s','m8');

set(handles.locateBt,'Enable','off')
set(handles.thresholdBt,'Enable','off')
refreshText(handles)
% hObject    handle to Bt5 (see GCBO)




% --- Executes on button press in Bt2.
function Bt2_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
if mode ~= 4
    dataBuffer = [];
end
mode = 4
mm=5;
a = 109;

fprintf(b,'%s','m5');

set(handles.locateBt,'Enable','off')
set(handles.thresholdBt,'Enable','off')
refreshText(handles)
% hObject    handle to Bt2 (see GCBO)




% --- Executes on button press in Bt4.
function Bt4_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
if mode ~= 4
    dataBuffer = [];
end
mode = 4
mm=6;
a = 109;

fprintf(b,'%s','m6');

set(handles.locateBt,'Enable','off')
set(handles.thresholdBt,'Enable','off')
refreshText(handles)





% --- Executes on button press in Bt3.
function Bt3_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
if mode ~= 4
    dataBuffer = [];
end
mode = 4
mm=7;
a = 109;

fprintf(b,'%s','m7');

set(handles.locateBt,'Enable','off')
set(handles.thresholdBt,'Enable','off')
refreshText(handles)
% hObject    handle to Bt3 (see GCBO)




% --- Executes on button press in Bt6.
function Bt6_Callback(hObject, eventdata, handles)
global b
global mode
global dataBuffer
if mode ~= 4
    dataBuffer = [];
end
mode = 4
mm=9;
a = 109;

fprintf(b,'%s','m9');

set(handles.locateBt,'Enable','off')
set(handles.thresholdBt,'Enable','off')
refreshText(handles)
% hObject    handle to Bt6 (see GCBO)




% --- Executes on button press in closeBt.
function closeBt_Callback(hObject, eventdata, handles)
% hObject    handle to closeBt (see GCBO)


global b
a = 120;
fprintf(b,'%c',a);
refreshText(handles)


% --- Executes on button press in locateBt.
function locateBt_Callback(hObject, eventdata, handles)
% hObject    handle to locateBt (see GCBO)


global b
global dataH
global dataX
global dataY
global mode
global dataBuffer
if mode == 2
  
    
    [~,location] = min(dataH);

    a = "l";
    x = dataX(location);
    y = dataY(location);
    if x == 0
        x = 1;
    end
    if y == 0
        y = 1;
    end
    a = strcat(a,char(x));
    
    a = strcat(a,char(y));
    
    fprintf(b,'%s',a);
    
end

mode = 1;
dataBuffer = [];
set(handles.locateBt,'Enable','off');
refreshText(handles)

function thresholdEd_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdEd (see GCBO)



% Hints: get(hObject,'String') returns contents of thresholdEd as text
%        str2double(get(hObject,'String')) returns contents of thresholdEd as a double


% --- Executes during object creation, after setting all properties.
function thresholdEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdEd (see GCBO)

% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in thresholdBt.
function thresholdBt_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdBt (see GCBO)


global threshold
global b
global mode
if mode ==3
    t = str2num(get(handles.thresholdEd,'String'));
    if t > 15 && t < 100
        threshold = t;
        a = "t";
        a = strcat(a,char(threshold));
        fprintf(b,'%s',a);
        
    else
        set(handles.thresholdEd,'String','X');
    end
end
refreshText(handles)
