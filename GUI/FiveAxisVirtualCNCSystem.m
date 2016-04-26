function varargout = FiveAxisVirtualCNCSystem(varargin)
% FIVEAXISVIRTUALCNCSYSTEM MATLAB code for FiveAxisVirtualCNCSystem.fig
%      FIVEAXISVIRTUALCNCSYSTEM, by itself, creates a new FIVEAXISVIRTUALCNCSYSTEM or raises the existing
%      singleton*.
%
%      H = FIVEAXISVIRTUALCNCSYSTEM returns the handle to a new FIVEAXISVIRTUALCNCSYSTEM or the handle to
%      the existing singleton*.
%
%      FIVEAXISVIRTUALCNCSYSTEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIVEAXISVIRTUALCNCSYSTEM.M with the given input arguments.
%
%      FIVEAXISVIRTUALCNCSYSTEM('Property','Value',...) creates a new FIVEAXISVIRTUALCNCSYSTEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FiveAxisVirtualCNCSystem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FiveAxisVirtualCNCSystem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows onlFy one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FiveAxisVirtualCNCSystem

% Last Modified by GUIDE v2.5 29-Feb-2016 22:20:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FiveAxisVirtualCNCSystem_OpeningFcn, ...
                   'gui_OutputFcn',  @FiveAxisVirtualCNCSystem_OutputFcn, ...
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
% ����ļ�Ŀ¼����Ϊ������ģ����ã��������Ŀ¼���ܲ��ҵ���صĺ���
addpath('..\Feedrate Schedule\');
addpath('..\Feedrate Schedule\Sshapefeedrateschedule');
addpath('..\Feedrate Schedule\Timeoptimalfeedrateschedule');
addpath('..\Interpolation\');
addpath('..\PostProcessing\');
addpath('..\ToolPathSmoothing\DualQuaternionApproximationWithDominantPoints\');
addpath('..\ToolPathSmoothing\DualQuaternionInterpolation\');
addpath('..\ToolPathSmoothing\FourSplineInterpolation_Yuen\');
addpath('..\ToolPathSmoothing\ThreeSplineInterpolation_Fleisig\');
addpath('..\ToolPathSmoothing\TwoSplineInterpolation_Langeron\');
addpath('..\Common\');
addpath('..\Resource');
addpath('..\Interpolation\secondorderTaylorinterp');


% End initialization code - DO NOT EDIT


% --- Executes just before FiveAxisVirtualCNCSystem is made visible.
function FiveAxisVirtualCNCSystem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FiveAxisVirtualCNCSystem (see VARARGIN)

% Choose default command line output for FiveAxisVirtualCNCSystem


handles.fontsizelabel = 15;
handles.fontsize = 14;
handles.linewidth = 1.5;

handles.output = hObject;
%% ��·��˳ģ���ʼ��
handles.smoothpath.method = 1;

%% �ٶȹ滮ģ���ʼ��
handles.feedrateschedule.method = 2;

%% �岹����ģ���ʼ��
handles.interp.method = 2;

%% ��ʾ���ý��ȣ���Ҫ��Ϊ�˷��㱣���Լ��������һ����ʾ
handles.step = 0;



machinetoolfig = imread('˫ת̨.bmp');
% machinetoolfig = imread('AC˫��ͷģ��.bmp');
axes(handles.machinetoolconfig_axes);
imshow(machinetoolfig);
handles.machinetype = 1; 

set(handles.pathsmoothpic_axes, 'position', [4, 0.4, 137.4, 18.6]);
smoothapathfig = imread('������ѡ��Ķ�ż��Ԫ�����.jpg');
axes(handles.pathsmoothpic_axes);
imagesc(smoothapathfig);

axis off

set(handles.feedrateschedulingmethod_axis, 'position', [5.8, 1.38, 141, 20]);
axes(handles.feedrateschedulingmethod_axis);
feedrateschedulefig = imread('ʱ�������ٶȹ滮.bmp');
imagesc(feedrateschedulefig);
axis off

axes(handles.interp_axes);
interpfig = imread('����̩��.bmp');
imagesc(interpfig);
axis off


% Update handles structure
guidata(hObject, handles);
set(handles.Axesmoverangesetting_panel, 'position', [4.6, 14, 55, 14.5]);
set(handles.rotarytablesetting_uipanel, 'position', [4.2, 29, 55, 6.85], 'visible', 'on');
set(handles.rotaryspindlesetting_uipanel, 'position', [4.2, 29, 55, 4.8], 'visible', 'off');
set(handles.Axesmoverangesetting_panel, 'position', [4.6, 14, 55, 14.5]);
% UIWAIT makes FiveAxisVirtualCNCSystem wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FiveAxisVirtualCNCSystem_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function OpenProject_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function SaveProject_Callback(hObject, eventdata, handles)
% ����˵�
if handles.step > 0
	% ����0�����ʾ�Ѿ�����˻����ṹ����
    saveproject.step = handles.step;	% ���浱ǰ����
	saveproject.machinetype = handles.machinetype;	% �����������
	% ���ݻ����ṹ������ṹ��صĲ���
	if handles.machinetype == 1
		saveproject.rotarytable = handles.rotarytable;
	elseif handles.machinetype == 2
		saveproject.rotaryspindle = handles.rotaryspindle;
	end
	saveproject.axesmoverangesetting = handles.axesmoverangesetting;
	
	if handles.step > 1
		% ˵���Ѿ�����˶�ȡ��·�ļ�
		saveproject.linearpath = handles.linearpath;
		
		if handles.step > 2
			% ˵���Ѿ�����˵�·��˳
			saveproject.smoothpath = handles.smoothpath;
		end
	end
end

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)

% --- Executes on button press in interpolation_togglebutton.
function interpolation_togglebutton_Callback(hObject, eventdata, handles)


% ģ��ѡ���Ч����ʵ���Ͼ��Ƕ�����л���ʾ���������ּӴ�����������
set(handles.machinetoolconfig_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.toolpath_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.toolpathsmooth_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.feedrateschedule_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.interpolation_togglebutton, 'Value', 1, 'backgroundcolor', [0.941 0.941 0.941], 'fontweight', 'bold', 'fontsize', 12);

set(handles.machinetoolconfig_panel,  'visible', 'off');
set(handles.toolpath_panel,  'visible', 'off');
set(handles.toolpathsmooth_panel,  'visible', 'off');
set(handles.feedrateschedule_panel,  'visible', 'off');
set(handles.interpolation_panel,  'visible', 'on');

drawnow expose       
% Hint: get(hObject,'Value') returns toggle state of interpolation_togglebutton


% --- Executes on button press in feedrateschedule_togglebutton.
function feedrateschedule_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to feedrateschedule_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ģ��ѡ���Ч����ʵ���Ͼ��Ƕ�����л���ʾ���������ּӴ�����������
set(handles.machinetoolconfig_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.toolpath_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.toolpathsmooth_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.feedrateschedule_togglebutton, 'Value', 1, 'backgroundcolor', [0.941 0.941 0.941], 'fontweight', 'bold', 'fontsize', 12);
set(handles.interpolation_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);

set(handles.machinetoolconfig_panel,  'visible', 'off');
set(handles.toolpath_panel,  'visible', 'off');
set(handles.toolpathsmooth_panel,  'visible', 'off');
set(handles.feedrateschedule_panel,  'visible', 'on');
set(handles.interpolation_panel,  'visible', 'off');

drawnow expose       
% Hint: get(hObject,'Value') returns toggle state of feedrateschedule_togglebutton


% --- Executes on button press in toolpath_togglebutton.
function toolpath_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to toolpath_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ģ��ѡ���Ч����ʵ���Ͼ��Ƕ�����л���ʾ���������ּӴ�����������
set(handles.machinetoolconfig_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.toolpath_togglebutton, 'Value', 1, 'backgroundcolor', [0.941 0.941 0.941], 'fontweight', 'bold', 'fontsize', 12);
set(handles.toolpathsmooth_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.feedrateschedule_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.interpolation_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);

set(handles.machinetoolconfig_panel,  'visible', 'off');
set(handles.toolpath_panel,  'visible', 'on');
set(handles.toolpathsmooth_panel,  'visible', 'off');
set(handles.feedrateschedule_panel,  'visible', 'off');
set(handles.interpolation_panel,  'visible', 'off');

drawnow expose       
% Hint: get(hObject,'Value') returns toggle state of toolpath_togglebutton


% --- Executes on button press in toolpathsmooth_togglebutton.
function toolpathsmooth_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to toolpathsmooth_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ģ��ѡ���Ч����ʵ���Ͼ��Ƕ�����л���ʾ���������ּӴ�����������
set(handles.machinetoolconfig_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.toolpath_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.toolpathsmooth_togglebutton, 'Value', 1, 'backgroundcolor', [0.941 0.941 0.941], 'fontweight', 'bold', 'fontsize', 12);
set(handles.feedrateschedule_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.interpolation_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);

set(handles.machinetoolconfig_panel,  'visible', 'off');
set(handles.toolpath_panel,  'visible', 'off');
set(handles.toolpathsmooth_panel,  'visible', 'on');
set(handles.feedrateschedule_panel,  'visible', 'off');
set(handles.interpolation_panel,  'visible', 'off');

drawnow expose       
% Hint: get(hObject,'Value') returns toggle state of toolpathsmooth_togglebutton



function opentoolpathfilename_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function opentoolpathfilename_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in opentoolpathfile_pushbutton.
function opentoolpathfile_pushbutton_Callback(hObject, eventdata, handles)

% �򿪶�ȡ�ļ��Ի������������ļ�������
[filename, pahtname, filerindex] = uigetfile({'*.txt;*.cl;*.mat'}, 'ѡ��·���ļ�',  '../Data/Input/');

% �����ȡ�ļ�ʧ�ܣ���ֱ���˳���������ʧ����ʾ��Ϣ��
try
    data = importdata([pahtname filename]); % ��������
catch err
    if filename ~= 0
        % ʧ�����׳�������Ϣ
        h = msgbox(err.message, '��ȡ�ļ�ʧ��');
        ah = get( h, 'CurrentAxes' );  
        ch = get( ah, 'Children' );  
        set( ch, 'fontname', '΢���ź�'); 
        set(handles.pathfilenotification_text, 'string', '��·���ļ�ʧ�ܣ������¼��ص���·���ļ���');
    end
    return;
end

% ����ȡ���ĵ���·������������
handles.linearpath.filename = [pahtname filename];

set(handles.opentoolpathfilename_edit, 'string', [pahtname filename])


% data = importdata([pahtname filename]); % ��������

% ���ֻ��һ�����ݵ㣬��ô˵���ļ��к����ַ����������ȡ�ļ��ķ�ʽ���ж�ȡ
if size(data, 1) == 1
    % ��ȡ�ļ��к���'GOTO\'�ַ�������
    ATPfile = fopen([pahtname filename], 'r');
    rowNum = 1;
    while ~feof(ATPfile)
        fscanf(ATPfile, '%c', 5);             %��ȡÿ��ǰ���GOTO/  
        data2(rowNum, 1:6) = fscanf(ATPfile, '%f,%f,%f,%f,%f,%f');%��ȡ����ֵ
        rowNum = rowNum + 1;
    end
    fclose(ATPfile);
    handles.linearpath.data = data2;
    noticestr = ['��ȡ����·�ļ����� ' num2str(size(data2, 1)) ' ����λ��'];
else
    handles.linearpath.data = data;
    noticestr = ['��ȡ����·�ļ����� ' num2str(size(data, 1)) ' ����λ��'];
end

handles.step = 2;	% ��·��ȡ��ɣ�������Ϣ
noticestr = [noticestr, '�� ��һ�����е�·��˳��'];
handles.noticestring = noticestr;	% ������ʾ��Ϣ

% set(handles.pathfilenotification_text, 'string', noticestr);
set(handles.notification_text, 'string', noticestr);
guidata(hObject,handles);

% ��Щ�ؼ�ֻ���ڶ�ȡ������·�������ʹ��
% set(handles.linearpathprevier_pushbutton, 'enable', 'on');
set(handles.linearpathfileopen_pushbutton, 'enable', 'on');
set(handles.smoothcal_pushbutton, 'enable', 'on');

tooltip = handles.linearpath.data(:, 1:3);
toolrfp = handles.linearpath.data(:, 1:3) + 10 * handles.linearpath.data(:, 4:6);
axes(handles.showinputpath_axes);
plot3(tooltip(:, 1), tooltip(:, 2), tooltip(:, 3));
hold on;
plot3(toolrfp(:, 1), toolrfp(:, 2), toolrfp(:, 3), 'r');

for i = 1:size(tooltip, 1)
    plot3([tooltip(i, 1), toolrfp(i, 1)], [tooltip(i, 2), toolrfp(i, 2)], [tooltip(i, 3), toolrfp(i, 3)]);
end
% set(gca, 'fontsize', 20);



% --- Executes on button press in linearpathprevier_pushbutton.
function linearpathprevier_pushbutton_Callback(hObject, eventdata, handles)
tooltip = handles.linearpath.data(:, 1:3);
toolrfp = handles.linearpath.data(:, 1:3) + 10 * handles.linearpath.data(:, 4:6);
figure;
plot3(tooltip(:, 1), tooltip(:, 2), tooltip(:, 3));
hold on;
plot3(toolrfp(:, 1), toolrfp(:, 2), toolrfp(:, 3), 'r');

for i = 1:size(tooltip, 1)
    plot3([tooltip(i, 1), toolrfp(i, 1)], [tooltip(i, 2), toolrfp(i, 2)], [tooltip(i, 3), toolrfp(i, 3)]);
end
set(gca, 'fontsize', 20);
title('���Ե���·��');

% --- Executes on button press in linearpathfileopen_pushbutton.
function linearpathfileopen_pushbutton_Callback(hObject, eventdata, handles)

currentfold = cd;   % ��ȡ��ǰ·��
% system('notepad handles.linearpath.filename &');
str = ['dos(' '''notepad ' handles.linearpath.filename ' &'');'];
eval(str);          % ����windows�Դ��ļ��±�������ı�
cd(currentfold);    % ���ڵ���notepad.exe��Ŀ¼���л���system32��ȥ���������л�����

function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)

rmpath('..\Feedrate Schedule\');
rmpath('..\Interpolation\');
rmpath('..\PostProcessing\');
rmpath('..\ToolPathSmoothing\DualQuaternionApproximationWithDominantPoints\');
rmpath('..\ToolPathSmoothing\DualQuaternionInterpolation\');
rmpath('..\ToolPathSmoothing\FourSplineInterpolation_Yuen\');
rmpath('..\ToolPathSmoothing\ThreeSplineInterpolation_Fleisig\');
rmpath('..\ToolPathSmoothing\TwoSplineInterpolation_Langeron\');
rmpath('..\Common\');


% --- Executes on button press in smoothcal_pushbutton.
function smoothcal_pushbutton_Callback(hObject, eventdata, handles)

set(handles.notification_text, 'string',  '�����У����Ե�...');
%set(handles.pathsmoothingnotice_text, 'string', '�����У����Ե�...');
drawnow expose       
t1 = tic;
% ���ݲ�ͬ�����ã����ò�ͬ�Ĺ�˳�㷨

noticestring = ' ';

% ����try catch����׽�쳣�����������������֪��
try
    if handles.smoothpath.method == 1
        %% ������ѡ��Ķ�ż��Ԫ���ƽ�����

        % ��ȡ������ѡ���㷨����Ҫ�õ���5����ֵ
        curvaturethr_dpselection = str2double(get(handles.curvaturedominantselect_edit, 'string'));
        tipchordthr_dpselection = str2double(get(handles.tooltipdominantselect_edit, 'string'));
        orientationchordthr_dpselection = str2double(get(handles.toolotrientationdominantselect_edit, 'string'));
        tipiterativeaccuracy_dpselection = str2double(get(handles.tooltipiterativeaccuracy_edit, 'string'));
        orientationiterativeaccuracy_spselection = str2double(get(handles.toolorientationiterativeaccuracy_edit, 'string'));
        
        if isnan(curvaturethr_dpselection) || isnan(tipchordthr_dpselection) || isnan(orientationchordthr_dpselection) || isnan(tipiterativeaccuracy_dpselection) || isnan(orientationiterativeaccuracy_spselection)
            error('��������ȷ�Ĳ���');
        end
        parameterizationmethod = get(handles.parameterizationmethod_popupmenu, 'value');    % ����������
        splineorder = get(handles.curveorder_popupmenu, 'value') + 1;           % ��Ͻ���
		
		% �������õĲ��������㱣�湤����
		handles.smoothpath.dpselection.curvaturethr_dpselection = curvaturethr_dpselection;
		handles.smoothpath.dpselection.tipchordthr_dpselection = tipchordthr_dpselection;
		handles.smoothpath.dpselection.orientationchordthr_dpselection = orientationchordthr_dpselection;
% 		handles.smoothpath.dpselection.
		
		
        % ����������ѡ��Ķ�ż��Ԫ����·����㷨
        [CQ, U, errtip, errorie, tip0, vector0] = dualquaternionapproximationwithdominantpoints...
        (handles.linearpath.data, splineorder, curvaturethr_dpselection, tipchordthr_dpselection, orientationchordthr_dpselection,...
        tipiterativeaccuracy_dpselection, orientationiterativeaccuracy_spselection, parameterizationmethod);

        % ����������
        handles.smoothpath.dualquatpath.errtip = errtip;
        handles.smoothpath.dualquatpath.errorie = errorie;

        % ������ƶ�ż��Ԫ��
        handles.smoothpath.dualquatpath.dualquatspline.controlp = CQ;
        handles.smoothpath.dualquatpath.dualquatspline.knotvector = U;
        handles.smoothpath.dualquatpath.dualquatspline.splineorder = splineorder;

        % �����ż��Ԫ��Ҫ�õ��ĳ�ʼ�����͵�������
        handles.smoothpath.dualquatpath.tip0 = tip0;
        handles.smoothpath.dualquatpath.vector0 = vector0;

        set(handles.showothers_pushbutton, 'string', '����͵���ʸ��');
        noticestring = 'ʹ�û���������ѡ��Ķ�ż��Ԫ����Ϸ���';
        feedrateschedulingnoticestring = '��������Լ��ֵ';
        
    elseif handles.smoothpath.method == 2
        %% ��ż��Ԫ����ֵ����
        parameterizationmethod = get(handles.parameterizationmethod_popupmenu, 'value');    % ����������
        splineorder = get(handles.curveorder_popupmenu, 'value') + 1;           % ��Ͻ���

        % �Զ�ż��Ԫ�����в�ֵ���õ�������Ԫ���ͽڵ�ʸ��
        [CQ, U, tip0, vector0] = dualquaternioninterpolation(handles.linearpath.data, splineorder, parameterizationmethod);

        % ������ƶ�ż��Ԫ��
        handles.smoothpath.dualquatpath.dualquatspline.controlp = CQ;
        handles.smoothpath.dualquatpath.dualquatspline.knotvector = U;
        handles.smoothpath.dualquatpath.dualquatspline.splineorder = splineorder;

        % �����ż��Ԫ��Ҫ�õ��ĳ�ʼ�����͵�������
        handles.smoothpath.dualquatpath.tip0 = tip0;
        handles.smoothpath.dualquatpath.vector0 = vector0;

        set(handles.showothers_pushbutton, 'string', '����͵���ʸ��');
        noticestring = 'ʹ�ö�ż��Ԫ����ֵ����';
        feedrateschedulingnoticestring = '��������Լ��ֵ';
    
    elseif handles.smoothpath.method == 3
        %% ��������ֵ����
        [Q, U, polycoef, startl, sublen, B, W, LW, WQ] = foursplineinterp(handles.linearpath.data);

        % �������������
        handles.smoothpath.foursplineinterpath.tipspline.controlp = Q;
        handles.smoothpath.foursplineinterpath.tipspline.knotvector = U;
        handles.smoothpath.foursplineinterpath.tipspline.splineorder = 5;

        % �����l-u����
        handles.smoothpath.foursplineinterpath.feedcorrectionspline.A = polycoef;
        handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl = startl;
        handles.smoothpath.foursplineinterpath.feedcorrectionspline.sublength = sublen;

        % ����ʸ����������
        handles.smoothpath.foursplineinterpath.orientationspline.controlp = B;
        handles.smoothpath.foursplineinterpath.orientationspline.knotvector = W;
        handles.smoothpath.foursplineinterpath.orientationspline.splineorder = 5;

        % ����ʸ�����²���������
        handles.smoothpath.foursplineinterpath.orientationreparam.LW = LW;
        handles.smoothpath.foursplineinterpath.orientationreparam.WQ = WQ;

        set(handles.showothers_pushbutton, 'string', '������������');
        noticestring = 'ʹ����������ֵ����';
        feedrateschedulingnoticestring = '�ݲ�֧�ִ˸�ʽ�ĵ���·��';
        
    elseif handles.smoothpath.method == 4
        %% ��������ֵ����
        [L, C, V, D, u, h] = threesplineinterp(handles.linearpath.data);

        handles.smoothpath.threesplineinterppath.tipspline.L = L;
        handles.smoothpath.threesplineinterppath.tipspline.C = C;

        handles.smoothpath.threesplineinterppath.orientationspline.V = V;
        handles.smoothpath.threesplineinterppath.orientationspline.D = D;

        handles.smoothpath.threesplineinterppath.reparam.u = u;
        handles.smoothpath.threesplineinterppath.reparam.h = h;

        set(handles.showothers_pushbutton, 'string', '������������');
        noticestring = 'ʹ����������ֵ����';
        feedrateschedulingnoticestring = '�ݲ�֧�ִ˸�ʽ�ĵ���·��';
        
    elseif handles.smoothpath.method == 5
        %% ˫������ֵ����
        toollength = str2double(get(handles.tipreferencedist_edit, 'string'));  % �������
        splineorder = get(handles.splineorder_popupmenu, 'value') + 1;              % ��������
        
        if isnan(toollength)
            error('��������ȷ�Ĳ���');
        end
        
        [CQ, U] = dualsplineinterp(handles.linearpath.data, splineorder, toollength);

        % �������õ�������
        handles.smoothpath.dualsplinepath.pathspline.controlp = CQ;
        handles.smoothpath.dualsplinepath.pathspline.knotvector = U;
        handles.smoothpath.dualsplinepath.pathspline.splineorder = splineorder;

        handles.smoothpath.dualsplinepath.toollength = toollength;

        set(handles.showothers_pushbutton, 'string', '�Ⱦ����');
        noticestring = 'ʹ��˫������ֵ����';
        feedrateschedulingnoticestring = '�ݲ�֧�ִ˸�ʽ�ĵ���·��';
    end
 
    set(handles.showlinearpath_pushbutton, 'enable', 'on');
    set(handles.showsplinepath_pushbutton, 'enable', 'on');
    set(handles.showlinearandsplinepath_pushbutton, 'enable', 'on');

    if handles.smoothpath.method == 1
        set(handles.showfittingerror_pushbutton, 'enable', 'on');
    else
        set(handles.showfittingerror_pushbutton, 'enable', 'off');
    end
    set(handles.showcurvature_pushbutton, 'enable', 'on');
    set(handles.showothers_pushbutton, 'enable', 'on');
    set(handles.savesmoothpath_pushbutton, 'enable', 'on');
    set(handles.smoothreport_pushbutton, 'enable', 'on');
    handles.smoothpath.caltime = toc(t1);      % ͳ�Ƽ���ʱ��
	
	handles.noticestring = [noticestring, '��˳��·���, ��ʱ ', num2str(handles.smoothpath.caltime), 's�� ��һ�������ٶȹ滮'];
	set(handles.notification_text, 'string', handles.noticestring);
 %   set(handles.pathsmoothingnotice_text, 'string', [noticestring, '��˳��·���, ��ʱ ', num2str(handles.smoothpath.caltime), 's']); 
    set(handles.feedrateschedulenotification_text, 'string', feedrateschedulingnoticestring);
	handles.step = 3;
catch exception
    % ��ʾ����
    msgbox(exception.message, '�������');
	set(handles.notification_text, 'string', '��·��˳�������������ѡ���˳�������趨������');
    % set(handles.pathsmoothingnotice_text, 'string', '�������'); 
%     rethrow(exception);
end



guidata(hObject,handles);   % ��������

% --- Executes on button press in showlinearpath_pushbutton.
function showlinearpath_pushbutton_Callback(hObject, eventdata, handles)

% ��ʾ���Ե���·��
noticestr = get(handles.pathsmoothingnotice_text, 'string');
set(handles.pathsmoothingnotice_text, 'string', '�����У����Ե�...');

tip = handles.linearpath.data(:, 1:3);
rp = tip + 10 * handles.linearpath.data(:, 4:6);

figure('units','normalized','position',[0.1,0.1,0.5,0.5]);

plot3(tip(:, 1), tip(:, 2), tip(:, 3));
hold on;
plot3(rp(:, 1), rp(:, 2), rp(:, 3));
set(gca, 'fontsize', 20, 'fontname', '΢���ź�');
title('���Ե���·��');

set(handles.pathsmoothingnotice_text, 'string', '���Ե�·��ʾ���');
guidata(hObject,handles);   % ��������

% --- Executes on button press in showsplinepath_pushbutton.
function showsplinepath_pushbutton_Callback(hObject, eventdata, handles)

noticestr = get(handles.pathsmoothingnotice_text, 'string');
set(handles.pathsmoothingnotice_text, 'string', '�����У����Ե�...');
drawnow expose       
if handles.smoothpath.method == 1 || handles.smoothpath.method == 2
    %% ������ѡ��Ķ�ż��Ԫ���ƽ��������ż��Ԫ����ֵ����
    du = 0.001;
    tip2 = handles.smoothpath.dualquatpath.tip0 + 10 * handles.smoothpath.dualquatpath.vector0;
    i = 1;
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.dualquatpath.dualquatspline, 0);	% ����²������Լ�һ���׵�ʸ
        curvepr(i, :) = TransformViaQ(tip2, DeBoorP(1, :));
        curvept(i, :) = TransformViaQ(handles.smoothpath.dualquatpath.tip0, DeBoorP(1, :));
        i = i + 1;
    end
    figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3));
    title('��Ϻ�ĵ���·��');
    set(gca, 'fontsize', 20, 'fontname', '΢���ź�');
    
    
elseif handles.smoothpath.method == 3
    %% ��������ֵ����
	slindex = 1;
	swindex = 1;
	pnum = 1;
    for s = 0:0.1:handles.smoothpath.foursplineinterpath.orientationreparam.LW(end, 1)
		% ���ҵ�s���ڵ������
		if s > handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl(slindex)...
				+ handles.smoothpath.foursplineinterpath.feedcorrectionspline.sublength(slindex)
			slindex = slindex + 1;
		end
		u = CaculateuWhithl(s,...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.A(slindex, :),...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl(slindex),...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.sublength(slindex));
		
		% �󵶼������
		curvept(pnum, :) = DeBoorCoxNurbsCal(u, handles.smoothpath.foursplineinterpath.tipspline, 0);
		
		if s > handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex + 1, 1)
			swindex = swindex + 1;
		end
		
		% ���Ӧ�ĵ���ʸ������w
		r = (s - handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex, 1))...
		/ (handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex + 1, 1)...
		- handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex, 1));
		
		w = 0;
		for i = 0:1:7
			w = w + factorial(7) / factorial(i) / factorial(7 - i) * (1 - r)^(7 - i) * r^i *...
			handles.smoothpath.foursplineinterpath.orientationreparam.WQ(8 * (swindex - 1) + 1 + i);
        end
		
		orien = DeBoorCoxNurbsCal(w, handles.smoothpath.foursplineinterpath.orientationspline, 0);
		
		I = sin(orien(1)) * cos(orien(2));
		J = sin(orien(1)) * sin(orien(2));
		K = cos(orien(1));
		
		curvepr(pnum, :) = curvept(pnum, :) + 10 * [I J K];
		
		pnum = pnum + 1;
    end
    figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3));
    title('��Ϻ�ĵ���·��');
    set(gca, 'fontsize', 20, 'fontname', '΢���ź�');
    
elseif handles.smoothpath.method == 4
    %% ��������ֵ����
    L = handles.smoothpath.threesplineinterppath.tipspline.L;
    C = handles.smoothpath.threesplineinterppath.tipspline.C;
    
    V = handles.smoothpath.threesplineinterppath.orientationspline.V;
    D = handles.smoothpath.threesplineinterppath.orientationspline.D;
    
    u = handles.smoothpath.threesplineinterppath.reparam.u;
    h = handles.smoothpath.threesplineinterppath.reparam.h;
    
    ds = 0.1;
    pnum = 1;
    %     for u = 0:0.01:L(i)
%         quinticSplineP(quiNum, :) = C(1, :, i) + C(2, :, i) * u + C(3, :, i) * u^2 + C(4, :, i) * u^3 + C(5, :, i) * u^4 + C(6, :, i) * u^5;
%         quiNum = quiNum + 1;
%     end

    lacc = zeros(1, length(L) + 1);
%     dacc = zeros(1, length(L));
    for i = 1:length(L)
        lacc(i + 1) = lacc(i) + L(i);
        dacc(i) = sum(D(1:i));
        for s = 0:ds:L(i)
            curvept(pnum, :) = C(1, :, i) + C(2, :, i) * s + C(3, :, i) * s^2 + C(4, :, i) * s^3 + C(5, :, i) * s^4 + C(6, :, i) * s^5;
            v = (u(i + 1) * s^2 + L(i) / D(i) * (u(i + 1) * h(i) + u(i) * h(i + 1)) * s * (L(i) - s) + u(i) * (L(i) - s)^2) / (s^2 + L(i) / D(i) * (h(i) + h(i + 1)) * s * (L(i) - s) + (L(i) - s)^2) - u(i);
            tvector(pnum, :) = QuinticSphericalBezier(V(1, :, i), V(2, :, i), V(3, :, i), V(4, :, i) , V(5, :, i), V(6, :, i), D(i), v);
            
            curvepr(pnum, :) = curvept(pnum, :) + 10 * tvector(pnum, :);
            pnum = pnum + 1;
        end
    end
    

    figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3), 'r');
    
elseif handles.smoothpath.method == 5
    %% ˫������ֵ����
    du = 0.001;
    i = 1;
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.dualsplinepath.pathspline, 0);	% ����²������Լ�һ���׵�ʸ
        curvept(i, :) = DeBoorP(1:3);
        curvepr(i, :) = DeBoorP(4:6);
        i = i + 1;
    end
    
    figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3), 'r');
end


set(handles.pathsmoothingnotice_text, 'string', '��Ϻ�ĵ�·��ʾ���');
guidata(hObject,handles);   % ��������

% --- Executes on button press in showlinearandsplinepath_pushbutton.
function showlinearandsplinepath_pushbutton_Callback(hObject, eventdata, handles)

noticestr = get(handles.pathsmoothingnotice_text, 'string');
set(handles.pathsmoothingnotice_text, 'string', '�����У����Ե�...');
drawnow expose       

tip = handles.linearpath.data(:, 1:3);
rp = tip + 10 * handles.linearpath.data(:, 4:6);

if handles.smoothpath.method == 1 | handles.smoothpath.method == 2
    %% ������ѡ��Ķ�ż��Ԫ���ƽ��������ż��Ԫ����ֵ����
    du = 0.001;
    tip2 = handles.smoothpath.dualquatpath.tip0 + 10 * handles.smoothpath.dualquatpath.vector0;
    i = 1;
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.dualquatpath.dualquatspline, 0);	% ����²������Լ�һ���׵�ʸ
        curvepr(i, :) = TransformViaQ(tip2, DeBoorP(1, :));
        curvept(i, :) = TransformViaQ(handles.smoothpath.dualquatpath.tip0, DeBoorP(1, :));
        i = i + 1;
    end
    figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3));

    
    
elseif handles.smoothpath.method == 3
    %% ��������ֵ����
	slindex = 1;
	swindex = 1;
	pnum = 1;
    ds = 0.01;
    for s = 0:ds:handles.smoothpath.foursplineinterpath.orientationreparam.LW(end, 1)
		% ���ҵ�s���ڵ������
		if s > handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl(slindex)...
				+ handles.smoothpath.foursplineinterpath.feedcorrectionspline.sublength(slindex)
			slindex = slindex + 1;
		end
		u = CaculateuWhithl(s,...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.A(slindex, :),...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl(slindex),...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.sublength(slindex));
		if u < 0
            u = 0;
        end
        
        if u > 1
            u = 1;
        end
        
		% �󵶼������
		curvept(pnum, :) = DeBoorCoxNurbsCal(u, handles.smoothpath.foursplineinterpath.tipspline, 0);
		
		if s > handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex + 1, 1)
			swindex = swindex + 1;
		end
		
		% ���Ӧ�ĵ���ʸ������w
		r = (s - handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex, 1))...
		/ (handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex + 1, 1)...
		- handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex, 1));
		
		w = 0;
		for i = 0:1:7
			w = w + factorial(7) / factorial(i) / factorial(7 - i) * (1 - r)^(7 - i) * r^i *...
			handles.smoothpath.foursplineinterpath.orientationreparam.WQ(8 * (swindex - 1) + 1 + i);
        end
        
        if w < 0
            w = 0;
        end
        if w > 1
            w = 1;
        end
        
		orien = DeBoorCoxNurbsCal(w, handles.smoothpath.foursplineinterpath.orientationspline, 0);
		
		I = sin(orien(1)) * cos(orien(2));
		J = sin(orien(1)) * sin(orien(2));
		K = cos(orien(1));
		
		curvepr(pnum, :) = curvept(pnum, :) + 10 * [I J K];
		
		pnum = pnum + 1;
    end
    figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3));
    title('��Ϻ�ĵ���·��');
    set(gca, 'fontsize', 20, 'fontname', '΢���ź�');
    
elseif handles.smoothpath.method == 4
    %% ��������ֵ����
    L = handles.smoothpath.threesplineinterppath.tipspline.L;
    C = handles.smoothpath.threesplineinterppath.tipspline.C;
    
    V = handles.smoothpath.threesplineinterppath.orientationspline.V;
    D = handles.smoothpath.threesplineinterppath.orientationspline.D;
    
    u = handles.smoothpath.threesplineinterppath.reparam.u;
    h = handles.smoothpath.threesplineinterppath.reparam.h;
    
    ds = 0.1;
    pnum = 1;
    %     for u = 0:0.01:L(i)
%         quinticSplineP(quiNum, :) = C(1, :, i) + C(2, :, i) * u + C(3, :, i) * u^2 + C(4, :, i) * u^3 + C(5, :, i) * u^4 + C(6, :, i) * u^5;
%         quiNum = quiNum + 1;
%     end

    lacc = zeros(1, length(L) + 1);
%     dacc = zeros(1, length(L));
    for i = 1:length(L)
        lacc(i + 1) = lacc(i) + L(i);
        dacc(i) = sum(D(1:i));
        for s = 0:ds:L(i)
            su = s / (L(i));
            curvept(pnum, :) = C(1, :, i) + C(2, :, i) * s + C(3, :, i) * s^2 + C(4, :, i) * s^3 + C(5, :, i) * s^4 + C(6, :, i) * s^5;
            v = (u(i + 1) * s^2 + L(i) / D(i) * (u(i + 1) * h(i) + u(i) * h(i + 1)) * s * (L(i) - s) + u(i) * (L(i) - s)^2) / (s^2 + L(i) / D(i) * (h(i) + h(i + 1)) * s * (L(i) - s) + (L(i) - s)^2) - u(i);
            tvector(pnum, :) = QuinticSphericalBezier(V(1, :, i), V(2, :, i), V(3, :, i), V(4, :, i) , V(5, :, i), V(6, :, i), D(i), v);
            
            curvepr(pnum, :) = curvept(pnum, :) + 10 * tvector(pnum, :);
            
            sarray(pnum) = lacc(i) + s;
            varray(pnum) = u(i) + v;
            pnum = pnum + 1;
        end
    end
    


    figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3));
    
elseif handles.smoothpath.method == 5
    %% ˫������ֵ����
    du = 0.001;
    i = 1;
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.dualsplinepath.pathspline, 0);	% ����²������Լ�һ���׵�ʸ
        curvept(i, :) = DeBoorP(1:3);
        curvepr(i, :) = DeBoorP(4:6);
        i = i + 1;
    end
    
    figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3));
end
title('��Ϻ�ĵ���·�������Ե���·��');
set(gca, 'fontsize', 20, 'fontname', '΢���ź�');
plot3(tip(:, 1), tip(:, 2), tip(:, 3), 'r');
plot3(rp(:, 1), rp(:, 2), rp(:, 3), 'r');

set(handles.pathsmoothingnotice_text, 'string', '���Ե�·����Ϻ�ĵ�·��ʾ���');
guidata(hObject,handles);   % ��������

% --- Executes on button press in showcurvature_pushbutton.
function showcurvature_pushbutton_Callback(hObject, eventdata, handles)

set(handles.pathsmoothingnotice_text, 'string', '�����У����Ե�...');
drawnow expose       
i = 1;
if handles.smoothpath.method == 1 || handles.smoothpath.method == 2
    %% ������ѡ��Ķ�ż��Ԫ���ƽ������Ͷ�ż��Ԫ����ֵ����
    du = 0.001;
    
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.dualquatpath.dualquatspline, 2);	% ����²������Լ�һ���׵�ʸ
        [der1, der2] = DerCalFromQ(handles.smoothpath.dualquatpath.tip0, DeBoorP(2, :), DeBoorP(3, :), DeBoorP(1, :));    % ��һ���׵�ʸ
        curvatureNurbs(i) = norm(cross(der1, der2)) / norm(der1)^3;                        % �������ʹ�ʽ������
        i = i + 1;
    end
    
elseif handles.smoothpath.method == 3
    %% ��������ֵ����
    pNum = 1;
    du = 0.001;
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.foursplineinterpath.tipspline, 2);
        curvatureNurbs(pNum) = norm(cross(DeBoorP(2, :), DeBoorP(3, :))) / norm(DeBoorP(2, :))^3;
        pNum = pNum + 1;
    end
    
elseif handles.smoothpath.method == 4
    %% ��������ֵ����
    curvatureNurbs = caculateCurvature(handles.smoothpath.threesplineinterppath.tipspline.L, handles.smoothpath.threesplineinterppath.tipspline.C);
    
elseif handles.smoothpath.method == 5
    %% ˫������ֵ����
    du = 0.001;
    pNum = 1;
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.dualsplinepath.pathspline, 2);	% ����²������Լ�һ���׵�ʸ
        curvatureNurbs(pNum) = norm(cross(DeBoorP(2, 1:3), DeBoorP(3, 1:3))) / norm(DeBoorP(2, 1:3))^3;
        pNum = pNum + 1;
    end
  
end
figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
plot(curvatureNurbs);
title('���������', 'fontsize', 20);
set(gca, 'fontsize', 20, 'fontname', '΢���ź�');
set(handles.pathsmoothingnotice_text, 'string', '�����������ʾ���');
guidata(hObject,handles);   % ��������

% --- Executes on button press in showfittingerror_pushbutton.
function showfittingerror_pushbutton_Callback(hObject, eventdata, handles)


% ����������
fontsize = 20;

figure('units','normalized','position',[0.05,0.1,0.9,0.7]);
subplot(1,2,1);
plot(handles.smoothpath.dualquatpath.errtip);  % ���Ƶ�����������
title('tool tip error(mm)','fontsize',fontsize);
set(gca, 'fontsize', fontsize);
subplot(1,2,2);
plot(handles.smoothpath.dualquatpath.errorie);  % ���Ƶ�����������
title('tool orientation error (��)','fontsize',fontsize)
set(gca, 'fontsize', fontsize);

% --- Executes on button press in showothers_pushbutton.
function showothers_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to showothers_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pathsmoothingnotice_text, 'string', '�����У����Ե�...');
drawnow expose       

if handles.smoothpath.method == 1 || handles.smoothpath.method == 2
    %% �ֱ���Ƶ����켣�͵���ʸ��
    du = 0.001;
    i = 1;
    v0dual = [0 handles.smoothpath.dualquatpath.vector0];
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.dualquatpath.dualquatspline, 0);	% ����²������Լ�һ���׵�ʸ
        curvepr(i, :) = TransformViaQ(handles.smoothpath.dualquatpath.tip0, DeBoorP(1, :));
        vectorarr(i, :) = quatmultiply(quatmultiply(DeBoorP(1, 1:4), v0dual), quatconj(DeBoorP(1, 1:4)));
        i = i + 1;
    end
    
    % ���Ƶ��������
    figure('units','normalized','position',[0.05,0.1,0.9,0.7]);
    subplot(1,2,1);
    plot3(curvepr(:, 1), curvepr(:, 2), curvepr(:, 3));
    set(gca, 'fontsize', 20);
    hold on;
    plot3(handles.linearpath.data(:, 1), handles.linearpath.data(:, 2), handles.linearpath.data(:, 3), '*');    % ���ƴ����ǰ����ɢ��
    
    % ���Ƶ���ʸ������
    subplot(1,2,2);
    plot3(vectorarr(:, 2), vectorarr(:, 3), vectorarr(:, 4));
    set(gca, 'fontsize', 20);
    hold on;
    [x, y, z] = sphere;
    mesh(x, y, z);      % ���Ƴ���������
    plot3(handles.linearpath.data(:, 4), handles.linearpath.data(:, 5), handles.linearpath.data(:, 6), '*');    % �������ǰ����ɢ��
    set(handles.pathsmoothingnotice_text, 'string', '����͵���ʸ���켣�������');
    
elseif handles.smoothpath.method == 3
    %% ��������������߲�ֵ�㷨��������������
    slindex = 1;
	swindex = 1;
    ds = 0.01;
    pnum = 1;
    for s = 0:ds:handles.smoothpath.foursplineinterpath.orientationreparam.LW(end, 1)
		% ���ҵ�s���ڵ������
		if s > handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl(slindex)...
				+ handles.smoothpath.foursplineinterpath.feedcorrectionspline.sublength(slindex)
			slindex = slindex + 1;
		end
		uarray(pnum) = CaculateuWhithl(s,...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.A(slindex, :),...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl(slindex),...
				handles.smoothpath.foursplineinterpath.feedcorrectionspline.sublength(slindex));
		
		if s > handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex + 1, 1)
			swindex = swindex + 1;
		end
		
		% ���Ӧ�ĵ���ʸ������w
		r = (s - handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex, 1))...
		/ (handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex + 1, 1)...
		- handles.smoothpath.foursplineinterpath.orientationreparam.LW(swindex, 1));
		
		warray(pnum) = 0;
		for i = 0:1:7
			warray(pnum) = warray(pnum) + factorial(7) / factorial(i) / factorial(7 - i) * (1 - r)^(7 - i) * r^i *...
			handles.smoothpath.foursplineinterpath.orientationreparam.WQ(8 * (swindex - 1) + 1 + i);
        end
        pnum = pnum + 1;
    end
    
    pnum = 1;
    du = 0.001;
    for u = 0:du:1
        % �󵶼������
        curvept(pnum, :) = DeBoorCoxNurbsCal(u, handles.smoothpath.foursplineinterpath.tipspline, 0);
        orien = DeBoorCoxNurbsCal(u, handles.smoothpath.foursplineinterpath.orientationspline, 0);
        I = sin(orien(1)) * cos(orien(2));
		J = sin(orien(1)) * sin(orien(2));
		K = cos(orien(1));
        tvector(pnum, :) = [I, J, K];
        
        pnum = pnum + 1;
    end
    s = 0:ds:handles.smoothpath.foursplineinterpath.orientationreparam.LW(end, 1);
    
    % ���Ƶ����켣����
    figure('units','normalized','position',[0.05,0.1,0.9,0.8]);
    subplot(2, 2, 1);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(handles.linearpath.data(:, 1), handles.linearpath.data(:, 2), handles.linearpath.data(:, 3), '*');    % ���ƴ����ǰ����ɢ��
    
    % ���Ƶ���ʸ����������
    subplot(2, 2, 2);
    plot3(tvector(:, 1), tvector(:, 2), tvector(:, 3));
    hold on;
    [x, y, z] = sphere;
    mesh(x, y, z);      % ���Ƴ���������
    plot3(handles.linearpath.data(:, 4), handles.linearpath.data(:, 5), handles.linearpath.data(:, 6), '*');    % �������ǰ����ɢ��
    
    % ����l-u����
    subplot(2, 2, 3);
    plot(s, uarray);
    title('l-u����');
    
    % ����l-w����
    subplot(2, 2, 4);
    plot(s, warray);
    title('l-w����');
    
    set(handles.pathsmoothingnotice_text, 'string', '���⡢����ʸ���켣��l-u���ߺ�l-w���߻������');
    
elseif handles.smoothpath.method == 4
    %% ��������������߲�ֵ�㷨��������������
        %% ��������ֵ����
    L = handles.smoothpath.threesplineinterppath.tipspline.L;
    C = handles.smoothpath.threesplineinterppath.tipspline.C;
    
    V = handles.smoothpath.threesplineinterppath.orientationspline.V;
    D = handles.smoothpath.threesplineinterppath.orientationspline.D;
    
    u = handles.smoothpath.threesplineinterppath.reparam.u;
    h = handles.smoothpath.threesplineinterppath.reparam.h;
    
    ds = 0.1;
    pnum = 1;
    %     for u = 0:0.01:L(i)
%         quinticSplineP(quiNum, :) = C(1, :, i) + C(2, :, i) * u + C(3, :, i) * u^2 + C(4, :, i) * u^3 + C(5, :, i) * u^4 + C(6, :, i) * u^5;
%         quiNum = quiNum + 1;
%     end

    lacc = zeros(1, length(L) + 1);
%     dacc = zeros(1, length(L));
    for i = 1:length(L)
        lacc(i + 1) = lacc(i) + L(i);
        dacc(i) = sum(D(1:i));
        for s = 0:ds:L(i)
            su = s / (L(i));
            curvept(pnum, :) = C(1, :, i) + C(2, :, i) * s + C(3, :, i) * s^2 + C(4, :, i) * s^3 + C(5, :, i) * s^4 + C(6, :, i) * s^5;
            v = (u(i + 1) * s^2 + L(i) / D(i) * (u(i + 1) * h(i) + u(i) * h(i + 1)) * s * (L(i) - s) + u(i) * (L(i) - s)^2) / (s^2 + L(i) / D(i) * (h(i) + h(i + 1)) * s * (L(i) - s) + (L(i) - s)^2) - u(i);
            tvector(pnum, :) = QuinticSphericalBezier(V(1, :, i), V(2, :, i), V(3, :, i), V(4, :, i) , V(5, :, i), V(6, :, i), D(i), v);
            
            curvepr(pnum, :) = curvept(pnum, :) + 10 * tvector(pnum, :);
            
            sarray(pnum) = lacc(i) + s;
            varray(pnum) = u(i) + v;
            pnum = pnum + 1;
        end
    end
    
    tip = handles.linearpath.data(:, 1:3);

    figure('units','normalized','position',[0.1,0.1,0.9,0.7]);
    subplot(2, 2, 1);
    plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3));
    hold on;
    plot3(tip(:, 1), tip(:, 2), tip(:, 3), 'r');
%     plot3(tip(:, 1), tip(:, 2), tip(:, 3), '*');
    title('���������');
    
    subplot(2, 2, 2);
    plot3(tvector(:, 1), tvector(:, 2), tvector(:, 3));
    hold on;
    [x, y, z] = sphere;
    mesh(x, y, z);      % ���Ƴ���������
    plot3(handles.linearpath.data(:, 4), handles.linearpath.data(:, 5), handles.linearpath.data(:, 6), 'r');
%     plot3(handles.linearpath.data(:, 4), handles.linearpath.data(:, 5), handles.linearpath.data(:, 6), '*');
    title('����ʸ������');
    
    subplot(2, 1, 2);
    plot(sarray, varray);
    hold on;
    plot(lacc, u, 'r');
    title('����ͬ������');
    
%     xcc = 50;
%     ycc = 50;
%     width = 400;
%     height= 300;
%     
%     figure('Position',[xcc, ycc, width, height]);
%     plot3(curvept(:, 1), curvept(:, 2), curvept(:, 3), 'linewidth', 1.5);
%     set(gca, 'fontsize', 15);
%     xlabel('X');
%     ylabel('Y');
%     zlabel('Z');
%     
%     figure('Position',[xcc, ycc, width, height]);
%     plot3(tvector(:, 1), tvector(:, 2), tvector(:, 3), 'linewidth', 3);
%     hold on;
%     [x, y, z] = sphere;
%     c = ones(size(x, 1), size(x, 2));
%     a = c * 0.8;
%     h = mesh(x, y, z);      % ���Ƴ���������
%     set(h,'EdgeColor','k','MarkerEdgecolor','r','MarkerFacecolor','r')
%     set(gca, 'fontsize', 15);
%     
%     figure('Position',[xcc, ycc, width + 100, height]);
%     plot(sarray, varray, 'linewidth', 3);
%     set(gca, 'fontsize', 15);
%     xlabel('l');
%     ylabel('u');
    
    
elseif handles.smoothpath.method == 5
    du = 0.001;
    pnum = 1;
    for u = 0:du:1
        DeBoorP = DeBoorCoxNurbsCal(u, handles.smoothpath.dualsplinepath.pathspline, 1);	% ����²������Լ�һ���׵�ʸ
        lengtherror(pnum) = norm(DeBoorP(1, 1:3) - DeBoorP(1, 4:6)) - handles.smoothpath.dualsplinepath.toollength;
        pnum = pnum + 1;
    end
    figure('units','normalized','position',[0.1,0.1,0.6,0.5]);
    plot(lengtherror);
end


% --- Executes on button press in savesmoothpath_pushbutton.
function savesmoothpath_pushbutton_Callback(hObject, eventdata, handles)

noticestr = get(handles.pathsmoothingnotice_text, 'string');
set(handles.pathsmoothingnotice_text, 'string', '�����У����Ե�...');
drawnow expose       

% ���ж��ļ��д�治���ڣ�����������򴴽��ļ���
dirc = ['..\Data\Output\' datestr(now, 29) ];
if exist([dirc '\smoothpath'], 'dir') == 0
    mkdir(dirc, 'smoothpath');
end

if handles.smoothpath.method == 1 || handles.smoothpath.method == 2
%% ������ѡ��Ķ�ż��Ԫ���ƽ������Ͷ�ż��Ԫ����ֵ����    
    
    % ���ҵ�ǰ���ڵ��ļ�����ӱ��ʹ�ļ�������
    fnum = 1;
    fdir = [dirc '\smoothpath\dualquatappropath' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
    while(exist(fdir, 'file') ~= 0)
        fnum = fnum + 1;
        fdir = [dirc '\smoothpath\dualquatappropath' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
    end
    
    % �����Ի���ѡ�񱣴��Ŀ¼���ļ���
    [filename, pahtname, filerindex] = uiputfile({'*.txt'}, '�����˳���·���ļ�',  fdir);
   
    
    try
        % �����ļ�
        wfile = fopen([pahtname filename], 'w+');
    catch err
        % ʧ�����׳����������Ϣ
        if pahtname ~= 0
            h = msgbox(err.message, '����ʧ��');
            ah = get( h, 'CurrentAxes' );  
            ch = get( ah, 'Children' );  
            set( ch, 'fontname', '΢���ź�'); 
        end
        return;
    end
    
    % �����ʼ��
    fprintf(wfile, '��ʼ������: [%f %f %f]\n\n', handles.smoothpath.dualquatpath.tip0(1), handles.smoothpath.dualquatpath.tip0(2), handles.smoothpath.dualquatpath.tip0(3));
    % �����ʼ����
    fprintf(wfile, '��ʼ����: [%f %f %f]\n\n', handles.smoothpath.dualquatpath.vector0(1), handles.smoothpath.dualquatpath.vector0(2), handles.smoothpath.dualquatpath.vector0(3));
    % ������������
    fprintf(wfile, '���������� %2.0f\n\n', handles.smoothpath.dualquatpath.dualquatspline.splineorder);
    
    % ����ڵ�����
    fprintf(wfile, '�ڵ�����\n U = [');
    for i = 1:length(handles.smoothpath.dualquatpath.dualquatspline.knotvector)
        fprintf(wfile, '%f, ', handles.smoothpath.dualquatpath.dualquatspline.knotvector(i));
        if mod(i, 10) == 0
            fprintf(wfile, '...\n');
        end
    end
    fprintf(wfile, '];\n\n');
    
    % ������ƶ�ż��Ԫ��
    fprintf(wfile, '���ƶ�ż��Ԫ��\n CQ = [ ... \n');
    for i = 1:size(handles.smoothpath.dualquatpath.dualquatspline.controlp, 1)
        for j = 1:size(handles.smoothpath.dualquatpath.dualquatspline.controlp, 2)
            fprintf(wfile, '%f ', handles.smoothpath.dualquatpath.dualquatspline.controlp(i, j));
        end
        fprintf(wfile, '\n');
    end
    fprintf(wfile, '];\n');
    
    fclose(wfile);
    msgbox(['��˳���·���ļ�������' pahtname filename], '��˳���·���ļ�����ɹ�');

elseif handles.smoothpath.method == 3
%% ��������ֵ����      
    
    % ���ҵ�ǰ���ڵ��ļ�����ӱ��ʹ�ļ�������
    fnum = 1;
    fdir = [dirc '\smoothpath\foursplineinterp' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
    while(exist(fdir, 'file') ~= 0)
        fnum = fnum + 1;
        fdir = [dirc '\smoothpath\foursplineinterp' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
    end
    
    % �����Ի���ѡ�񱣴��Ŀ¼���ļ���
    [filename, pahtname, filerindex] = uiputfile({'*.txt'}, '�����˳���·���ļ�',  fdir);
    
    try
        % �����ļ�
        wfile = fopen([pahtname filename], 'w+');
    catch err
        % ʧ�����׳����������Ϣ
        if pahtname ~= 0
            h = msgbox(err.message, '����ʧ��');
            ah = get( h, 'CurrentAxes' );  
            ch = get( ah, 'Children' );  
            set( ch, 'fontname', '΢���ź�'); 
        end
        return;
    end
    
    % д������
    fprintf(wfile, '\n\n----------------------���������--------------------------\n\n');
    fprintf(wfile, '��������: %2.0f \n\n', handles.smoothpath.foursplineinterpath.tipspline.splineorder);
    % ����ڵ�����
    fprintf(wfile, '�ڵ�����\n U = [');
    for i = 1:length(handles.smoothpath.foursplineinterpath.tipspline.knotvector)
        fprintf(wfile, '%f, ', handles.smoothpath.foursplineinterpath.tipspline.knotvector(i));
        if mod(i, 10) == 0
            fprintf(wfile, '...\n');
        end
    end
    fprintf(wfile, '];\n\n');
    
    % ������Ƶ�
    fprintf(wfile, '���ƶ���\n Q = [ ... \n');
    for i = 1:size(handles.smoothpath.foursplineinterpath.tipspline.controlp)
        for j = 1:3
            fprintf(wfile, '%f ', handles.smoothpath.foursplineinterpath.tipspline.controlp(i, j));
        end
        fprintf(wfile, '\n');
    end
    fprintf(wfile, '];\n\n');
    
    fprintf(wfile, '\n\n----------------------����l-u���߲���--------------------------\n\n');
    fprintf(wfile, '�����ֶε㣺\n');
    for i = 1:length(handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl)
        fprintf(wfile, '%f ', handles.smoothpath.foursplineinterpath.feedcorrectionspline.startl(i));
    end
    fprintf(wfile, '%f\n\n', handles.smoothpath.foursplineinterpath.orientationreparam.LW(end, 1));
    fprintf(wfile, '����ʽϵ����\n');
    
    for i = 1:size(handles.smoothpath.foursplineinterpath.feedcorrectionspline.A, 1)
        for j = 1:size(handles.smoothpath.foursplineinterpath.feedcorrectionspline.A, 2)
            fprintf(wfile, '%f ', handles.smoothpath.foursplineinterpath.feedcorrectionspline.A(i, j));
        end
        fprintf(wfile, '\n');
    end
    
    fprintf(wfile, '\n\n----------------------��ʸ������--------------------------\n\n');
    fprintf(wfile, '��������: %2.0f \n\n', handles.smoothpath.foursplineinterpath.orientationspline.splineorder);
    % ����ڵ�����
    fprintf(wfile, '�ڵ�����\n U = [');
    for i = 1:length(handles.smoothpath.foursplineinterpath.orientationspline.knotvector)
        fprintf(wfile, '%f, ', handles.smoothpath.foursplineinterpath.orientationspline.knotvector(i));
        if mod(i, 10) == 0
            fprintf(wfile, '...\n');
        end
    end
    fprintf(wfile, '];\n\n');
    
    % ������Ƶ�
    fprintf(wfile, '���ƶ���\n Q = [ ... \n');
    for i = 1:size(handles.smoothpath.foursplineinterpath.orientationspline.controlp)
        for j = 1:2
            fprintf(wfile, '%f ', handles.smoothpath.foursplineinterpath.orientationspline.controlp(i, j));
        end
        fprintf(wfile, '\n');
    end
    fprintf(wfile, '];\n\n');
    
    fprintf(wfile, '\n\n----------------------��ʸ��l-w���߲���--------------------------\n\n');
    fprintf(wfile, '�ֶε㣺\n');
    for i = 1:size(handles.smoothpath.foursplineinterpath.orientationreparam.LW, 1)
        fprintf(wfile, '%f ', handles.smoothpath.foursplineinterpath.orientationreparam.LW(i, 1));
        if mod(i, 10) == 0
            fprintf(wfile, '...\n');
        end
    end
    
    fprintf(wfile, '\n\n����ʽϵ����\n');
    for i = 1:size(handles.smoothpath.foursplineinterpath.orientationreparam.WQ, 1) / 8
        for j = 1:8
            fprintf(wfile, '%f ', handles.smoothpath.foursplineinterpath.orientationreparam.WQ(8 * (i - 1) + j));
        end
        fprintf(wfile, '...\n');
    end
    
    
    % �ر��ļ�����ʾ
    fclose(wfile);
    h = msgbox(['��˳���·���ļ�������' pahtname filename], '��˳���·���ļ�����ɹ�');
    ah = get( h, 'CurrentAxes' );  
    ch = get( ah, 'Children' );  
    set( ch, 'fontname', '΢���ź�'); 
    
    
elseif handles.smoothpath.method == 4
    %% ��������ֵ����
    % ���ҵ�ǰ���ڵ��ļ�����ӱ��ʹ�ļ�������
    fnum = 1;
    fdir = [dirc '\smoothpath\threesplineinterp' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
    while(exist(fdir, 'file') ~= 0)
        fnum = fnum + 1;
        fdir = [dirc '\smoothpath\threesplineinterp' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
    end
    
    % �����Ի���ѡ�񱣴��Ŀ¼���ļ���
    [filename, pahtname, filerindex] = uiputfile({'*.txt'}, '�����˳���·���ļ�',  fdir);
    
    try
        % �����ļ�
        wfile = fopen([pahtname filename], 'w+');
    catch err
        % ʧ�����׳����������Ϣ
        if pahtname ~= 0
            h = msgbox(err.message, '����ʧ��');
            ah = get( h, 'CurrentAxes' );  
            ch = get( ah, 'Children' );  
            set( ch, 'fontname', '΢���ź�'); 
        end
        return;
    end
    
    % д������
    fprintf(wfile, '\n\n----------------------���������--------------------------\n\n');
    
    L = handles.smoothpath.threesplineinterppath.tipspline.L;
    C = handles.smoothpath.threesplineinterppath.tipspline.C;
    
    V = handles.smoothpath.threesplineinterppath.orientationspline.V;
    D = handles.smoothpath.threesplineinterppath.orientationspline.D;
    
    u = handles.smoothpath.threesplineinterppath.reparam.u;
    h = handles.smoothpath.threesplineinterppath.reparam.h;
    
    fprintf(wfile, 'L = [...\n');
    for i = 1:length(L)
        fprintf(wfile, '%f ', L(i));
    end
    fprintf(wfile, '\n]\n\nC = [...\n');
    
    for i = 1:size(C, 3)
        for j = 1:size(C, 2)
            for k = 1:size(C, 1)
                fprintf(wfile, '%f ', C(k, j, i));
            end
            fprintf(wfile, '\n');
        end
    end
    
    fprintf(wfile, ']\n\n----------------------����ʸ������--------------------------\n\nD = [...\n');
    for i = 1:length(D)
        fprintf(wfile, '%f ', D(i));
    end
    
    fprintf(wfile, ']\n\nV = [...\n');
    for i = 1:size(V, 3)
        for j = 1:size(V, 2)
            for k = 1:size(V, 1)
                fprintf(wfile, '%f ', V(k, j, i));
            end
            fprintf(wfile, '\n');
        end
    end
    
    fprintf(wfile, ']\n\n----------------------����ͬ������--------------------------\n\nu = [...\n');
    for i = 1:length(u)
        fprintf(wfile, '%f ', u(i));
    end
    
    fprintf(wfile, ']\n\nh = [...\n');
    for i = 1:length(h)
        fprintf(wfile, '%f ', h(i));
    end
    fprintf(wfile, '\n]');
    
    fclose(wfile);
    
elseif handles.smoothpath.method == 5
    %% ˫������ֵ����
    % ���ҵ�ǰ���ڵ��ļ�����ӱ��ʹ�ļ�������
    fnum = 1;
    fdir = [dirc '\smoothpath\dualsplineinterppath' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
    while(exist(fdir, 'file') ~= 0)
        fnum = fnum + 1;
        fdir = [dirc '\smoothpath\dualsplineinterppath' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
    end
    
    % �����Ի���ѡ�񱣴��Ŀ¼���ļ���
    [filename, pahtname, filerindex] = uiputfile({'*.txt'}, '�����˳���·���ļ�',  fdir);
   
    
    try
        % �����ļ�
        wfile = fopen([pahtname filename], 'w+');
    catch err
        % ʧ�����׳����������Ϣ
        if pahtname ~= 0
            h = msgbox(err.message, '����ʧ��');
            ah = get( h, 'CurrentAxes' );  
            ch = get( ah, 'Children' );  
            set( ch, 'fontname', '΢���ź�'); 
        end
        return;
    end
    % ���浶�߳���
    fprintf(wfile, '���߳��ȣ� %2.4f\n\n', handles.smoothpath.dualsplinepath.toollength);
    % ������������
    fprintf(wfile, '���������� %2.0f\n\n', handles.smoothpath.dualsplinepath.pathspline.splineorder);
    
    % ����ڵ�����
    fprintf(wfile, '�ڵ�����\n U = [');
    for i = 1:length(handles.smoothpath.dualsplinepath.pathspline.knotvector)
        fprintf(wfile, '%f, ', handles.smoothpath.dualsplinepath.pathspline.knotvector(i));
        if mod(i, 10) == 0
            fprintf(wfile, '...\n');
        end
    end
    fprintf(wfile, '];\n\n');
    
    % ������Ƶ�����
    fprintf(wfile, '���Ƶ�\n CQ = [ ... \n');
    for i = 1:size(handles.smoothpath.dualsplinepath.pathspline.controlp)
        for j = 1:6
            fprintf(wfile, '%f ', handles.smoothpath.dualsplinepath.pathspline.controlp(i, j));
        end
        fprintf(wfile, '\n');
    end
    fprintf(wfile, '];\n');
    
    fclose(wfile);
    msgbox(['��˳���·���ļ�������' pahtname filename], '��˳���·���ļ�����ɹ�');
end

set(handles.pathsmoothingnotice_text, 'string', '�ļ��������');
guidata(hObject,handles);   % ��������

% --- Executes on button press in smoothreport_pushbutton.
function smoothreport_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to smoothreport_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.smoothpath.method == 1
    % ������ѡ��Ķ�ż��Ԫ���ƽ�����


elseif handles.smoothpath.method == 2
    % ��ż��Ԫ����ֵ����

    
elseif handles.smoothpath.method == 3
    % ��������ֵ����

    
elseif handles.smoothpath.method == 4
    % ��������ֵ����

    
elseif handles.smoothpath.method == 5
    % ˫������ֵ����
  
end


function curvaturedominantselect_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function curvaturedominantselect_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tooltipdominantselect_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tooltipdominantselect_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function toolotrientationdominantselect_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function toolotrientationdominantselect_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in parameterizationmethod_popupmenu.
function parameterizationmethod_popupmenu_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function parameterizationmethod_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in curveorder_popupmenu.
function curveorder_popupmenu_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function curveorder_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tooltipiterativeaccuracy_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tooltipiterativeaccuracy_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function toolorientationiterativeaccuracy_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function toolorientationiterativeaccuracy_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function smoothmethod_uipanel_CreateFcn(hObject, eventdata, handles)
% ��ʼ��ʱ���ú�Ĭ�ϲ���
% ��·����˳�㷨����Ϊ��ż��Ԫ���ƽ�����
handles.smoothpath.method = 1;
guidata(hObject,handles);

% --- Executes when selected object is changed in smoothmethod_uipanel.
function smoothmethod_uipanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject��Ϊѡ�еľ�������ݾ���Ϳ���֪�����ĸ���ѡ��ѡ����
% ���ݹ�˳�����Ĳ�ͬ��ѡ�񣬵��������������λ�ÿɿ�������

guidata(hObject,handles);
if hObject == handles.dualquatappr_radiobutton
    set(handles.approximationparam_panel, 'position', [3.6 24.4 138.5 6.7], 'visible', 'on');
    set(handles.curveparam_panel, 'position', [3.6 19.2 138.5 4.7], 'visible', 'on');
    set(handles.dualsplineparameter_uipanel, 'visible', 'off');
    
    % ��·����˳�㷨����Ϊ��ż��Ԫ���ƽ�����
    handles.smoothpath.method = 1;
    pathsmoothingmethodintroductionstring = '������������Ļ���������ѡ��Ķ�ż��Ԫ����Ϸ���';
    
    set(handles.pathsmoothpic_axes, 'position', [21, 9, 687, 238]);
    smoothapathfig = imread('������ѡ��Ķ�ż��Ԫ�����.jpg');
    axes(handles.pathsmoothpic_axes);
    imagesc(smoothapathfig);

    axis off
    
    
elseif hObject == handles.duaquatinterp_radiobutton
    set(handles.approximationparam_panel, 'visible', 'off');
    set(handles.curveparam_panel, 'position', [3.6 25.2 138.5 5.3], 'visible', 'on');
    set(handles.dualsplineparameter_uipanel, 'visible', 'off');
    
    set(handles.pathsmoothpic_axes, 'position', [15, 9, 800, 310]);
    smoothapathfig = imread('��ż��Ԫ����ֵ.bmp');
    axes(handles.pathsmoothpic_axes);
    imshow(smoothapathfig);

    axis off
    
    % ��·����˳�㷨����Ϊ��ż��Ԫ����ֵ����
    handles.smoothpath.method = 2;
    pathsmoothingmethodintroductionstring = 'Bi, Q., et al., An algorithm to generate compact dual NURBS tool path with equal distance for 5-Axis NC machining, in Intelligent Robotics and Applications. 2010, Springer. p. 553-564.';
elseif hObject == handles.foursplineinterp_radiobutton 
    set(handles.approximationparam_panel, 'visible', 'off');
    set(handles.curveparam_panel, 'visible', 'off');
    set(handles.dualsplineparameter_uipanel, 'visible', 'off');
    
    set(handles.pathsmoothpic_axes, 'position', [21, 9, 687, 380]);
    smoothapathfig = imread('���������.bmp');
    axes(handles.pathsmoothpic_axes);
    imshow(smoothapathfig);

    axis off
    
    % ��·����˳�㷨����Ϊ��������ֵ����
    handles.smoothpath.method = 3;
    pathsmoothingmethodintroductionstring = 'Yuen, A., K. Zhang and Y. Altintas, Smooth trajectory generation for five-axis machine tools. International Journal of Machine Tools and Manufacture, 2013. 71(0): p. 11-19.';
elseif hObject == handles.threesplineinterp_radiobutton
    set(handles.approximationparam_panel, 'visible', 'off');
    set(handles.curveparam_panel, 'visible', 'off');
    set(handles.dualsplineparameter_uipanel, 'visible', 'off');
    
    % ��·����˳�㷨����Ϊ������ֵ����
    handles.smoothpath.method = 4;
    pathsmoothingmethodintroductionstring = 'Fleisig, R.V. and A.D. Spence, A constant feed and reduced angular acceleration interpolation algorithm for multi-axis machining. Computer-Aided Design, 2001. 33(1): p. 1 - 15.';

    set(handles.pathsmoothpic_axes, 'position', [21, 9, 687, 380]);
    smoothapathfig = imread('��������ֵ��˳.jpg');
    axes(handles.pathsmoothpic_axes);
    imagesc(smoothapathfig);

    axis off
    
elseif hObject == handles.dualsplineinterp_radiobutton 
    set(handles.approximationparam_panel, 'visible', 'off');
    set(handles.curveparam_panel, 'visible', 'off');
    set(handles.dualsplineparameter_uipanel, 'position', [3.6 25.5 138.5 5], 'visible', 'on');
    
    % ��·����˳�㷨����Ϊ˫����ֵ����
    handles.smoothpath.method = 5;
    pathsmoothingmethodintroductionstring = 'Langeron, J.M., et al., A new format for 5-axis tool path computation, using Bspline curves. Computer-Aided Design, 2004. 36(12): p. 1219-1229.';
    
    set(handles.pathsmoothpic_axes, 'position', [21, 9, 687, 310]);
    smoothapathfig = imread('˫B�������.bmp');
    axes(handles.pathsmoothpic_axes);
    imshow(smoothapathfig);

    axis off
    
end

set(handles.pathsmoothmethodintroduction_text, 'string', pathsmoothingmethodintroductionstring);
guidata(hObject,handles);
drawnow expose       


function tipreferencedist_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tipreferencedist_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in splineorder_popupmenu.
function splineorder_popupmenu_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function splineorder_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tooltipconstraint_checkbox.
function tooltipconstraint_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in toolorientationconstraint_checkbox.
function toolorientationconstraint_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in driveconstraint_checkbox.
function driveconstraint_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in cuttingforceconstraint_checkbox.
function cuttingforceconstraint_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in constraintssetting_pushbutton.
function constraintssetting_pushbutton_Callback(hObject, eventdata, handles)
% ��ȡ��ѡ���Լ��״̬
handles.constraints.selection.dynconstrsel = get(handles.tooltipconstraint_checkbox, 'value');
handles.constraints.selection.geoconstrsel = get(handles.geometryconstraint_checkbox, 'value');
handles.constraints.selection.oriconstrsel = get(handles.toolorientationconstraint_checkbox, 'value');
handles.constraints.selection.driconstrsel = get(handles.driveconstraint_checkbox, 'value');
handles.constraints.selection.forconstrsel = get(handles.cuttingforceconstraint_checkbox, 'value');

try
    % �򿪾�����������ӽ���
    handles.constraints.settings = feedratescheduleconstraintssetting(handles.constraints.selection);
    guidata(hObject, handles);      % ��������
    
    if isfield(handles.smoothpath, 'dualquatpath') == 1 &&...
            (handles.smoothpath.method == 1 || handles.smoothpath.method == 2) &&...
            handles.constraints.settings.error == 0
        set(handles.feedrateschedulenotification_text, 'string', 'Լ��������ɣ����Խ����ٶȹ滮��');
        set(handles.feedrateschedule_pushbutton, 'enable', 'on');
    elseif (handles.smoothpath.method ~= 1 && handles.smoothpath.method ~= 2)
        set(handles.feedrateschedulenotification_text, 'string', 'Լ��������ɣ���Ŀǰ��֧�ֶ�ż��Ԫ����ʽ�ĵ�·������˳�õ��ĵ�·��ʽ�ݲ�֧�֣�������ѡ��·��˳����');
    end
    
catch err
    msgbox(err.message, '��ȡ�ļ�ʧ��');
    rethrow(err);
end


% --- Executes on button press in feedrateschedule_pushbutton.
function feedrateschedule_pushbutton_Callback(hObject, eventdata, handles)

% ����岹���ڣ�����������ڽ����ٶȹ滮ʱ��Ҫ�õ�
handles.interpolationperiod = str2double(get(handles.interpolationperiod_edit, 'string')) / 1000;

set(handles.notification_text, 'string', '���ڽ����ٶȹ滮�����Ե�...');
drawnow expose       

% 2015-9-14 δ��ȡ�ٶȹ滮������ѡ�򣬳��ִ������ڹ滮ǰ��ȡһ����ѡ��ķ�����
if get(handles.Sschedule_radiobutton, 'value') == 1
    % ����1������S���ٶȹ滮
    handles.feedrateschedule.method = 1;
    handles.feedrateschedule.sshapeschedule = sshapefeedratescheduling(handles.constraints, handles.smoothpath, handles.interpolationperiod);
elseif get(handles.timeoptimschedule_radiobutton, 'value') == 1
    % ����2��ʱ�������ٶȹ滮������μ�ICIRA2015 ��An Adaptive Feedrate Scheduling Method with Multi-Constraints for Five-Axis Machine Tools��
    handles.feedrateschedule.method = 2;
    if handles.smoothpath.method == 1 || handles.smoothpath.method == 2
        % ����Ƕ�ż��Ԫ����ʽ�ĵ�·�����������ٶȹ滮����
        handles.feedrateschedule.timeoptimschedule = dualpathtimeoptimalfeedrateschedule(handles.constraints, handles.smoothpath.dualquatpath, handles.interpolationperiod, handles.machinetype);
    end
end
set(handles.interpcal_pushbutton, 'enable', 'on');
if handles.feedrateschedule.method == 1
    % ����S���ٶȹ滮�Ľ��
    handles.feedrateschedule.scheduleresult = calscheduleresult(handles.feedrateschedule.sshapeschedule, handles.smoothpath, handles.interpolationperiod);
elseif handles.feedrateschedule.method == 2
    
else
    
end

% ֻ�����ٶȹ滮֮�󣬲鿴�滮�����������ʹ��
set(handles.showFext_pushbutton, 'enable', 'on');
set(handles.showFsch_pushbutton, 'enable', 'on');
set(handles.showFdri_pushbutton, 'enable', 'on');
set(handles.showAsch_pushbutton, 'enable', 'on');
set(handles.showAdri_pushbutton, 'enable', 'on');
set(handles.showJsch_pushbutton, 'enable', 'on');
set(handles.showJdri_pushbutton, 'enable', 'on');
set(handles.savefeedrateschedule_pushbutton, 'enable', 'on');
set(handles.notification_text, 'string', '�ٶȹ滮������ ��һ�����в岹���㡣');
handles.step = 4;
handles.noticestring = '�ٶȹ滮������ ��һ�����в岹���㡣';
guidata(hObject, handles);      % ��������



% --- Executes on button press in geometryconstraint_checkbox.
function geometryconstraint_checkbox_Callback(hObject, eventdata, handles)

% --- Executes when selected object is changed in uipanel27.
function uipanel27_SelectionChangeFcn(hObject, eventdata, handles)
if hObject == handles.Sschedule_radiobutton
    handles.feedrateschedule.method = 1;
    set(handles.driveconstraint_checkbox, 'enable', 'off', 'value', 0);
    
    set(handles.feedrateschedulingmethod_axis, 'position', [5.8, 1.38, 141, 20]);
    axes(handles.feedrateschedulingmethod_axis);
    feedrateschedulefig = imread('S���ٶȹ滮.bmp');
    imshow(feedrateschedulefig);
    axis off
    
elseif hObject == handles.timeoptimschedule_radiobutton
    handles.feedrateschedule.method = 2;
    set(handles.driveconstraint_checkbox, 'enable', 'on', 'value', 1);
    
    set(handles.feedrateschedulingmethod_axis, 'position', [5.8, 1.38, 141, 20]);
    axes(handles.feedrateschedulingmethod_axis);
    feedrateschedulefig = imread('ʱ�������ٶȹ滮.bmp');
    imshow(feedrateschedulefig);
    axis off
else
    handles.feedrateschedule.method = 3;
end
guidata(hObject, handles);
    



function interpolationperiod_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function interpolationperiod_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showFext_pushbutton.
function showFext_pushbutton_Callback(hObject, eventdata, handles)
figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
if get(handles.Sschedule_radiobutton, 'value') == 1
    % ������õ�S���ٶȹ滮����
    plot(handles.feedrateschedule.scheduleresult.t, handles.feedrateschedule.scheduleresult.feedLimit);
    ylim([0 max(handles.feedrateschedule.scheduleresult.feedLimit)+10]);
    hold on;
    plot(handles.feedrateschedule.scheduleresult.t, handles.feedrateschedule.scheduleresult.sVelProfilePlan, 'r');
elseif get(handles.timeoptimschedule_radiobutton, 'value') == 1
    % �������ʱ�����ŵ��ٶȹ滮����
    % �����ٶȼ�ֵ����
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, handles.feedrateschedule.timeoptimschedule.scheduledresult.velolimtline, 'r', 'linewidth', handles.linewidth);
    hold on;
    
    % ��Ϊ�ȽϱȽϣ����滮����Ҳ���Ƴ���
    for i = 1:size(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, 1)
        feedp(i) = DeBoorCoxNurbsCal(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(i), handles.feedrateschedule.timeoptimschedule.feedratespline, 0);
    end
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, feedp, '--b', 'linewidth', handles.linewidth);
end
h = legend('�ٶȼ�ֵ����', '�ٶȹ滮����');
set(h,'Orientation','horizon');
set(gca, 'fontsize', handles.fontsize);
ylabel('�ٶ� (mm/s)', 'fontsize', handles.fontsizelabel);
xlabel('���� u', 'fontsize', handles.fontsizelabel);


% --- Executes on button press in showFsch_pushbutton.
function showFsch_pushbutton_Callback(hObject, eventdata, handles)

figure('units','normalized','position',[0.1,0.1,0.5,0.5]);

if get(handles.Sschedule_radiobutton, 'value') == 1
    plot(handles.feedrateschedule.scheduleresult.t, handles.feedrateschedule.scheduleresult.sVelProfilePlan);
    ylim([0 max(handles.feedrateschedule.scheduleresult.sVelProfilePlan)+10]);
elseif get(handles.timeoptimschedule_radiobutton, 'value') == 1
    % �������ʱ�����ŵ��ٶȹ滮����
    % �����ٶȼ�ֵ����
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, handles.feedrateschedule.timeoptimschedule.scheduledresult.velolimtline, 'r', 'linewidth', handles.linewidth);
    hold on;
    
    % ��Ϊ�ȽϱȽϣ����滮����Ҳ���Ƴ���
    for i = 1:size(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, 1)
        feedp(i) = DeBoorCoxNurbsCal(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(i, 1), handles.feedrateschedule.timeoptimschedule.feedratespline, 0);
    end
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, feedp, '--b', 'linewidth', handles.linewidth);
    h = legend('�ٶȼ�ֵ����', '�ٶȹ滮����');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', handles.fontsize);
    ylabel('�ٶ� (mm/s)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
end





% --- Executes on button press in showFdri_pushbutton.
function showFdri_pushbutton_Callback(hObject, eventdata, handles)
% ��ʾ�滮�ĸ����ٶ�����
if get(handles.Sschedule_radiobutton, 'value') == 1
    
elseif get(handles.timeoptimschedule_radiobutton, 'value') == 1
    figure('units','normalized','position',[0.1,0.1, 0.6, 0.4]);
    % ����ƽ������ٶ�����
    subplot(1,2,1);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, handles.feedrateschedule.timeoptimschedule.scheduledresult.VX, 'linewidth', 1.5);
    hold on;
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, handles.feedrateschedule.timeoptimschedule.scheduledresult.VY, 'r', 'linewidth', 1.5);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, handles.feedrateschedule.timeoptimschedule.scheduledresult.VZ, 'g', 'linewidth', 1.5);
    h = legend('X��', 'Y��', 'Z��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', handles.fontsize);
    ylabel('�ٶ� (mm/s)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
    ymax = max([max(handles.feedrateschedule.timeoptimschedule.scheduledresult.VX), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.VY), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.VZ)]);
    ymin = min([min(handles.feedrateschedule.timeoptimschedule.scheduledresult.VX), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.VY), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.VZ)]);
    ylim([ymin * 1.1, ymax* 1.6]);
    grid on;
    
    % ������ת����ٶ�����
    subplot(1, 2, 2);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, handles.feedrateschedule.timeoptimschedule.scheduledresult.VA, 'linewidth', 1.5);
    hold on;
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u, handles.feedrateschedule.timeoptimschedule.scheduledresult.VC, 'r', 'linewidth', 1.5);
    h = legend('A��', 'C��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('�ٶ� (rad/s)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
    ymax = max([max(handles.feedrateschedule.timeoptimschedule.scheduledresult.VA), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.VC)]);
    ymin = min([min(handles.feedrateschedule.timeoptimschedule.scheduledresult.VA), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.VC)]);
    ylim([ymin * 1.1, ymax* 1.4]);
    grid on;
end


% --- Executes on button press in showAsch_pushbutton.
% ��ʾ�滮�ĵ������ٶ�����
function showAsch_pushbutton_Callback(hObject, eventdata, handles)
figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
if get(handles.Sschedule_radiobutton, 'value') == 1
    % S�ι滮����
    plot(handles.feedrateschedule.scheduleresult.t, handles.feedrateschedule.scheduleresult.sAccPlan);
    ylim([0 max(handles.feedrateschedule.scheduleresult.sAccPlan)+100]); 
elseif get(handles.timeoptimschedule_radiobutton, 'value') == 1
    % ʱ�����Ź滮
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.tipA)), handles.feedrateschedule.timeoptimschedule.scheduledresult.tipA, 'linewidth', 1.5);
    h = legend('���ٶȹ滮ֵ');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('���ٶ� (mm/s^2)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
    ymax = max(handles.feedrateschedule.timeoptimschedule.scheduledresult.tipA);
    ymin = min(handles.feedrateschedule.timeoptimschedule.scheduledresult.tipA);
    ylim([ymin * 1.1, ymax* 1.3]);
    grid on;
end



% --- Executes on button press in showAdri_pushbutton.
function showAdri_pushbutton_Callback(hObject, eventdata, handles)
% ��ʾ�滮�ĸ����ٶ�����
if get(handles.Sschedule_radiobutton, 'value') == 1
    
elseif get(handles.timeoptimschedule_radiobutton, 'value') == 1
    figure('units','normalized','position',[0.1,0.1, 0.6, 0.4]);
    % ����ƽ������ٶ�����
    subplot(1,2,1);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.AX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.AX, 'linewidth', 1.5);
    hold on;
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.AX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.AY, 'r', 'linewidth', 1.5);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.AX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.AZ, 'g', 'linewidth', 1.5);
    h = legend('X��', 'Y��', 'Z��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', handles.fontsize);
    ylabel('���ٶ� (mm/s^2)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
    ymax = max([max(handles.feedrateschedule.timeoptimschedule.scheduledresult.AX), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.AY), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.AZ)]);
    ymin = min([min(handles.feedrateschedule.timeoptimschedule.scheduledresult.AX), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.AY), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.AZ)]);
    ylim([ymin * 1.1, ymax* 1.6]);
    grid on;
    
    % ������ת����ٶ�����
    subplot(1, 2, 2);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.AX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.AA, 'linewidth', 1.5);
    hold on;
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.AX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.AC, 'r', 'linewidth', 1.5);
    h = legend('A��', 'C��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('���ٶ� (rad/s^2)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
    ymax = max([max(handles.feedrateschedule.timeoptimschedule.scheduledresult.AA), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.AC)]);
    ymin = min([min(handles.feedrateschedule.timeoptimschedule.scheduledresult.AA), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.AC)]);
    ylim([ymin * 1.1, ymax* 1.4]);
    grid on;
end


% --- Executes on button press in showJsch_pushbutton.
function showJsch_pushbutton_Callback(hObject, eventdata, handles)
figure('units','normalized','position',[0.1,0.1,0.5,0.5]);

if get(handles.Sschedule_radiobutton, 'value') == 1
    % S�ι滮����
    plot(handles.feedrateschedule.scheduleresult.t, handles.feedrateschedule.scheduleresult.sJerkPlan);
elseif get(handles.timeoptimschedule_radiobutton, 'value') == 1
    % ʱ�����Ź滮
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.tipJ)), handles.feedrateschedule.timeoptimschedule.scheduledresult.tipJ, 'linewidth', 1.5);
    h = legend('Ծ�ȹ滮ֵ');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('Ծ�� (mm/s^3)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
    ymax = max(handles.feedrateschedule.timeoptimschedule.scheduledresult.tipJ);
    ymin = min(handles.feedrateschedule.timeoptimschedule.scheduledresult.tipJ);
    ylim([ymin * 1.1, ymax* 1.3]);
    grid on;
end

% --- Executes on button press in showJdri_pushbutton.
function showJdri_pushbutton_Callback(hObject, eventdata, handles)
if get(handles.Sschedule_radiobutton, 'value') == 1
    
elseif get(handles.timeoptimschedule_radiobutton, 'value') == 1
    figure('units','normalized','position',[0.1,0.1, 0.6, 0.4]);
    % ����ƽ�����Ծ������
    subplot(1,2,1);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.JX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.JX, 'linewidth', 1.5);
    hold on;
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.JX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.JY, 'r', 'linewidth', 1.5);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.JX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.JZ, 'g', 'linewidth', 1.5);
    h = legend('X��', 'Y��', 'Z��');
    set(h,'Orientation','horizon', 'box', 'off');
    set(gca, 'fontsize', handles.fontsize);
    ylabel('Ծ�� (mm/s^3)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
    ymax = max([max(handles.feedrateschedule.timeoptimschedule.scheduledresult.JX), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.JY), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.JZ)]);
    ymin = min([min(handles.feedrateschedule.timeoptimschedule.scheduledresult.JX), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.JY), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.JZ)]);
    ylim([ymin * 1.1, ymax* 1.6]);
    grid on;
    
    % ������ת����ٶ�����
    subplot(1, 2, 2);
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.JX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.JA, 'linewidth', 1.5);
    hold on;
    plot(handles.feedrateschedule.timeoptimschedule.scheduledresult.u(1:length(handles.feedrateschedule.timeoptimschedule.scheduledresult.JX)), handles.feedrateschedule.timeoptimschedule.scheduledresult.JC, 'r', 'linewidth', 1.5);
    h = legend('A��', 'C��');
    set(h,'Orientation','horizon', 'box', 'off');
    set(gca, 'fontsize', 15);
    ylabel('Ծ�� (rad/s^3)', 'fontsize', handles.fontsizelabel);
    xlabel('���� u', 'fontsize', handles.fontsizelabel);
    ymax = max([max(handles.feedrateschedule.timeoptimschedule.scheduledresult.JA), max(handles.feedrateschedule.timeoptimschedule.scheduledresult.JC)]);
    ymin = min([min(handles.feedrateschedule.timeoptimschedule.scheduledresult.JA), min(handles.feedrateschedule.timeoptimschedule.scheduledresult.JC)]);
    ylim([ymin * 1.1, ymax* 1.4]);
    grid on;
end

% --- Executes on button press in savefeedrateschedule_pushbutton.
function savefeedrateschedule_pushbutton_Callback(hObject, eventdata, handles)

% --- Executes on button press in interpcal_pushbutton.

function interpcal_pushbutton_Callback(hObject, eventdata, handles)
%% �ٶȹ滮����ģ��
set(handles.notification_text, 'string', '���ڽ��в岹���㣬���Ե�......');
drawnow;

if handles.feedrateschedule.method == 1
    % ����s���ٶȹ滮����
    
elseif handles.feedrateschedule.method == 2
    % ����ʱ�������ٶȹ滮����
    if handles.smoothpath.method == 1 || handles.smoothpath.method == 2
        % ���ڶ�ż��Ԫ����ʽ�ĵ�·���в岹����
        interpresult = dualquaternionspathsecondTaylorinterp(handles.feedrateschedule.timeoptimschedule.feedratespline, handles.smoothpath.dualquatpath, handles.interpolationperiod, handles.machinetype);
    else
        
    end
    % ���岹�õ��Ľ��������handles�ṹ����
    handles.interpresult = interpresult;
else
    % ��������
    
end
set(handles.notification_text, 'string', '�岹���������');
handles.step = 5;

% �岹��������ʾ����İ���ʹ��
set(handles.showvelo_pushbutton, 'enable', 'on');
set(handles.showaxesvel_pushbutton, 'enable', 'on');
set(handles.showacc_pushbutton, 'enable', 'on');
set(handles.showaxesacc_pushbutton, 'enable', 'on');
set(handles.showaxesjerk_pushbutton, 'enable', 'on');
set(handles.showactualjerk_pushbutton, 'enable', 'on');
set(handles.saveinterpresult_pushbutton, 'enable', 'on');
set(handles.postprocess_pushbutton, 'enable', 'on');
guidata(hObject, handles);

% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)

% --- Executes on button press in showvelo_pushbutton.
function showvelo_pushbutton_Callback(hObject, eventdata, handles)

figure('units','normalized','position',[0.1,0.1,0.5,0.5]);

if handles.interp.method == 1
    
elseif handles.interp.method == 2
    
    plot((1:length(handles.interpresult.actualf)) * handles.interpolationperiod, handles.interpresult.actualf, 'linewidth', 1.5);

    h = legend('�岹�����ʵ���ٶ�');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('�ٶ� (mm/s)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max(handles.interpresult.actualf);
    ymin = min(handles.interpresult.actualf);
    ylim([ymin * 1.1, ymax* 1.3]);
    xlim([0, length(handles.interpresult.actualf) * handles.interpolationperiod]);
    grid on;
else
    
end

% --- Executes on button press in showaxesvel_pushbutton.
function showaxesvel_pushbutton_Callback(hObject, eventdata, handles)


if handles.interp.method == 1
    
elseif handles.interp.method == 2
    figure('units','normalized','position',[0.1,0.1, 0.7, 0.4]);
    % ����ƽ������ٶ�����
    subplot(1,2,1);
    plot((1:length(handles.interpresult.actualf)) * handles.interpolationperiod, handles.interpresult.schedulMV(:, 3), 'linewidth', 1.5);
    hold on;
    plot((1:length(handles.interpresult.actualf)) * handles.interpolationperiod, handles.interpresult.schedulMV(:, 4), 'r', 'linewidth', 1.5);
    plot((1:length(handles.interpresult.actualf)) * handles.interpolationperiod, handles.interpresult.schedulMV(:, 5), 'g', 'linewidth', 1.5);
    h = legend('X��', 'Y��', 'Z��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', handles.fontsize);
    ylabel('�ٶ� (mm/s)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max([max(handles.interpresult.schedulMV(:, 3)), max(handles.interpresult.schedulMV(:, 4)), max(handles.interpresult.schedulMV(:, 5))]);
    ymin = min([min(handles.interpresult.schedulMV(:, 3)), min(handles.interpresult.schedulMV(:, 4)), min(handles.interpresult.schedulMV(:, 5))]);
    ylim([ymin * 1.1, ymax* 1.6]);
    xlim([0, length(handles.interpresult.actualf) * handles.interpolationperiod]);
    grid on;
    
    % ������ת����ٶ�����
    subplot(1, 2, 2);
    plot((1:length(handles.interpresult.actualf)) * handles.interpolationperiod, handles.interpresult.schedulMV(:, 1), 'linewidth', 1.5);
    hold on;
    plot((1:length(handles.interpresult.actualf)) * handles.interpolationperiod, handles.interpresult.schedulMV(:, 2), 'r', 'linewidth', 1.5);
    h = legend('A��', 'C��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('�ٶ� (rad/s)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max([max(handles.interpresult.schedulMV(:, 1)), max(handles.interpresult.schedulMV(:, 2))]);
    ymin = min([min(handles.interpresult.schedulMV(:, 1)), min(handles.interpresult.schedulMV(:, 2))]);
    ylim([ymin * 1.1, ymax* 1.4]);
    xlim([0, length(handles.interpresult.actualf) * handles.interpolationperiod]);
    grid on;
else
    
end

% --- Executes on button press in showacc_pushbutton.
function showacc_pushbutton_Callback(hObject, eventdata, handles)
% ����������ٶ�����
if handles.interp.method == 1
    
elseif handles.interp.method == 2
    figure('units','normalized','position',[0.1,0.1, 0.5, 0.4]);
    
    % ��ʵ�ʵ������ٶ�
    actualacc = zeros(length(handles.interpresult.actualf) - 1, 1);
    
    for i = 1:length(handles.interpresult.actualf) - 1
        actualacc(i) = (handles.interpresult.actualf(i + 1) - handles.interpresult.actualf(i)) / handles.interpolationperiod;
    end
    plot((1:length(actualacc)) * handles.interpolationperiod, actualacc, 'linewidth', 1.5);

    h = legend('���ʵ�ʼ��ٶ�');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('���ٶ� (mm/s^2)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max(actualacc);
    ymin = min(actualacc);
    ylim([ymin * 1.1, ymax* 1.3]);
    xlim([0, length(actualacc) * handles.interpolationperiod]);
    grid on;
else
    
end


% --- Executes on button press in showaxesacc_pushbutton.
function showaxesacc_pushbutton_Callback(hObject, eventdata, handles)
if handles.interp.method == 1
    
elseif handles.interp.method == 2
    actualMA = zeros(length(handles.interpresult.actualf) - 1, 5);
    
    for i = 1:length(handles.interpresult.actualf) - 1
        actualMA(i, :) = (handles.interpresult.actualMV(i + 1, :) - handles.interpresult.actualMV(i, :)) / handles.interpolationperiod;
    end
    figure('units','normalized','position',[0.1,0.1, 0.7, 0.4]);
    % ����ƽ����ļ��ٶ�����
    subplot(1,2,1);
    plot((1:(length(handles.interpresult.actualf) - 1)) * handles.interpolationperiod, actualMA(:, 3), 'linewidth', 1.5);
    hold on;
    plot((1:(length(handles.interpresult.actualf) - 1)) * handles.interpolationperiod, actualMA(:, 4), 'r', 'linewidth', 1.5);
    plot((1:(length(handles.interpresult.actualf) - 1)) * handles.interpolationperiod, actualMA(:, 5), 'g', 'linewidth', 1.5);
    h = legend('X��', 'Y��', 'Z��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', handles.fontsize);
    ylabel('���ٶ� (mm/s^2)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max([max(actualMA(:, 3)), max(actualMA(:, 4)), max(actualMA(:, 5))]);
    ymin = min([min(actualMA(:, 3)), min(actualMA(:, 4)), min(actualMA(:, 5))]);
    ylim([ymin * 1.1, ymax* 1.6]);
    xlim([0, length(handles.interpresult.actualf) * handles.interpolationperiod]);
    grid on;
    
    % ������ת��ļ��ٶ�����
    subplot(1, 2, 2);
    plot((1:(length(handles.interpresult.actualf) - 1)) * handles.interpolationperiod, actualMA(:, 1), 'linewidth', 1.5);
    hold on;
    plot((1:(length(handles.interpresult.actualf) - 1)) * handles.interpolationperiod, actualMA(:, 2), 'r', 'linewidth', 1.5);
    h = legend('A��', 'C��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('���ٶ� (rad/s^2)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max([max(actualMA(:, 1)), max(actualMA(:, 2))]);
    ymin = min([min(actualMA(:, 1)), min(actualMA(:, 2))]);
    ylim([ymin * 1.1, ymax* 1.4]);
    xlim([0, length(handles.interpresult.actualf) * handles.interpolationperiod]);
    grid on;
else
    
end


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)

% --- Executes on button press in showaxesjerk_pushbutton.
function showaxesjerk_pushbutton_Callback(hObject, eventdata, handles)
% ���Ƹ���ʵ��Ծ������
if handles.interp.method == 1
    
elseif handles.interp.method == 2
    actualMJ = zeros(length(handles.interpresult.actualf) - 2, 5);
    
    for i = 1:length(handles.interpresult.actualf) - 2
        actualMJ(i, :) = (handles.interpresult.actualMV(i + 2, :) - 2 * handles.interpresult.actualMV(i + 1, :) + handles.interpresult.actualMV(i, :)) / handles.interpolationperiod ^ 2;
    end
    figure('units','normalized','position',[0.1,0.1, 0.7, 0.4]);
    % ����ƽ����ļ��ٶ�����
    subplot(1,2,1);
    plot((5:(length(handles.interpresult.actualf) - 2)) * handles.interpolationperiod, actualMJ(5:end, 3), 'linewidth', 1.5);
    hold on;
    plot((5:(length(handles.interpresult.actualf) - 2)) * handles.interpolationperiod, actualMJ(5:end, 4), 'r', 'linewidth', 1.5);
    plot((5:(length(handles.interpresult.actualf) - 2)) * handles.interpolationperiod, actualMJ(5:end, 5), 'g', 'linewidth', 1.5);
    h = legend('X��', 'Y��', 'Z��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', handles.fontsize);
    ylabel('Ծ�� (mm/s^3)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max([max(actualMJ(5:end, 3)), max(actualMJ(5:end, 4)), max(actualMJ(5:end, 5))]);
    ymin = min([min(actualMJ(5:end, 3)), min(actualMJ(5:end, 4)), min(actualMJ(5:end, 5))]);
    ylim([ymin * 1.1, ymax* 1.6]);
    xlim([0, length(handles.interpresult.actualf) * handles.interpolationperiod]);
    grid on;
    
    % ������ת��ļ��ٶ�����
    subplot(1, 2, 2);
    plot((5:(length(handles.interpresult.actualf) - 2)) * handles.interpolationperiod, actualMJ(5:end, 1), 'linewidth', 1.5);
    hold on;
    plot((5:(length(handles.interpresult.actualf) - 2)) * handles.interpolationperiod, actualMJ(5:end, 2), 'r', 'linewidth', 1.5);
    h = legend('A��', 'C��');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('Ծ�� (rad/s^3)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max([max(actualMJ(5:end, 1)), max(actualMJ(5:end, 2))]);
    ymin = min([min(actualMJ(5:end, 1)), min(actualMJ(5:end, 2))]);
    ylim([ymin * 1.1, ymax* 1.4]);
    xlim([0, length(handles.interpresult.actualf) * handles.interpolationperiod]);
    grid on;
else
    
end

% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)

% --- Executes on button press in interpPoutput_checkbox.
function interpPoutput_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in interpVoutput_checkbox.
function interpVoutput_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in interpAoutput_checkbox.
function interpAoutput_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in threevectoroutput_checkbox.
function threevectoroutput_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in interpKoutput_checkbox.
function interpKoutput_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in interpToutput_checkbox.
function interpToutput_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in machinetoolconfig_togglebutton.
function machinetoolconfig_togglebutton_Callback(hObject, eventdata, handles)

set(handles.machinetoolconfig_togglebutton, 'Value', 1, 'backgroundcolor', [0.941 0.941 0.941], 'fontweight', 'bold', 'fontsize', 12);
set(handles.toolpath_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.toolpathsmooth_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.feedrateschedule_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);
set(handles.interpolation_togglebutton, 'Value', 0, 'backgroundcolor', [0.8 0.8 0.8], 'fontweight', 'normal', 'fontsize', 10);

set(handles.machinetoolconfig_panel,  'visible', 'on');
set(handles.toolpath_panel,  'visible', 'off');
set(handles.toolpathsmooth_panel,  'visible', 'off');
set(handles.feedrateschedule_panel,  'visible', 'off');
set(handles.interpolation_panel,  'visible', 'off');

drawnow expose       

% Hint: get(hObject,'Value') returns toggle state of machinetoolconfig_togglebutton


% --- Executes during object creation, after setting all properties.
function configurationselection_uipanel_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function machinetoolconfig_axes_CreateFcn(hObject, eventdata, handles)
% handles.machinetoolconfig_axes = hObject;
% machinetoolfig = imread('˫ת̨.bmp');
% % machinetoolfig = imread('AC˫��ͷģ��.bmp');
% axes(hObject);
% imshow(machinetoolfig);
% handles.machinetype = 1;    % ��ʼ����������
% guidata(hObject, handles);  % 2015-09-11���˷��ڻ������ͳ�ʼ��֮ǰ���������

% Hint: place code in OpeningFcn to populate machinetoolconfig_axes


% --- Executes during object creation, after setting all properties.
function machinetoolconfig_panel_CreateFcn(hObject, eventdata, handles)
% ������ʼ����ʱ�򽫻���������Ϊ1���������Ա�֤������
handles.machinetype = 1;
guidata(hObject,handles);

% --- Executes when selected object is changed in configurationselection_uipanel.
function configurationselection_uipanel_SelectionChangeFcn(hObject, eventdata, handles)
% ����ѡ�������Ӧ�Ļ���ͼƬ
axes(handles.machinetoolconfig_axes);
if hObject == handles.rotarytable_radiobutton
    machinetoolfig = imread('˫ת̨.bmp');
    imshow(machinetoolfig);
    set(handles.rotarytablesetting_uipanel, 'position', [4.2, 29, 55, 6.85], 'visible', 'on');
    set(handles.rotaryspindlesetting_uipanel, 'position', [4.2, 29, 55, 4.8], 'visible', 'off');
    set(handles.Axesmoverangesetting_panel, 'position', [4.6, 14, 55, 14.5]);
    handles.machinetype = 1;
elseif hObject == handles.rotaryspindle_radiobutton
    machinetoolfig = imread('AC˫��ͷģ��.bmp');
    imshow(machinetoolfig);
    set(handles.rotarytablesetting_uipanel, 'position', [4.2, 29, 55, 6.85], 'visible', 'off');
    set(handles.rotaryspindlesetting_uipanel, 'position', [4.2, 30.9, 55, 4.8], 'visible', 'on');
    set(handles.Axesmoverangesetting_panel, 'position', [4.6, 16, 55, 14.5]);
    handles.machinetype = 2;
end
guidata(hObject,handles);

% --- Executes on button press in machineconfigsettingok_pushbutton.
function machineconfigsettingok_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to machineconfigsettingok_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ȷ���趨�Ļ�������
if handles.machinetype == 1
    Lz = str2double(get(handles.rotarytableLz_edit, 'string'));
    Ly = str2double(get(handles.rotarytableLy_edit, 'string'));
    handles.rotarytable.Lz = Lz;
    handles.rotarytable.Ly = Ly;
    noticstring = ['�ѳɹ����û���Ϊ˫ת̨�ṹ��Z����ƫ��LzΪ ', get(handles.rotarytableLz_edit, 'string'), ' mm��Y����ƫ��LyΪ ', get(handles.rotarytableLy_edit, 'string'), ' mm'];

elseif handles.machinetype == 2
    L = str2double(get(handles.rotaryspindleL_edit, 'string'));
    handles.rotaryspindle.L = L;
    noticstring = ['�ѳɹ����û���Ϊ˫��ͷ�ṹ��Z����ƫ��LΪ ', get(handles.rotaryspindleL_edit, 'string'), ' mm'];
end
handles.axesmoverangesetting.xlow = str2double(get(handles.Xlimitlow_edit, 'string'));
handles.axesmoverangesetting.xup = str2double(get(handles.Xlimithigh_edit, 'string'));

handles.axesmoverangesetting.ylow = str2double(get(handles.Ylimitlow_edit, 'string'));
handles.axesmoverangesetting.yup = str2double(get(handles.Ylimithigh_edit, 'string'));

handles.axesmoverangesetting.zlow = str2double(get(handles.Zlimitlow_edit, 'string'));
handles.axesmoverangesetting.zup = str2double(get(handles.Zlimithigh_edit, 'string'));

handles.axesmoverangesetting.alow = str2double(get(handles.Alimitlow_edit, 'string'));
handles.axesmoverangesetting.aup = str2double(get(handles.Alimithigh_edit, 'string'));

handles.axesmoverangesetting.clow = str2double(get(handles.Climitlow_edit, 'string'));
handles.axesmoverangesetting.cup = str2double(get(handles.Climithigh_edit, 'string'));

handles.step = 1;	% ����������ɣ���¼����
noticstring = [noticstring, '�� ��һ������ӵ�·'];
set(handles.notification_text, 'string', noticstring);
handles.noticestring = noticstring;

guidata(hObject,handles);



function rotarytableLz_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function rotarytableLz_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rotarytableLy_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function rotarytableLy_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotaryspindleL_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function rotaryspindleL_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit30_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function machinetoolconfig_axes_ButtonDownFcn(hObject, eventdata, handles)


function uipanel27_CreateFcn(hObject, eventdata, handles)



function Xlimitlow_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Xlimitlow_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xlimithigh_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Xlimithigh_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ylimitlow_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Ylimitlow_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ylimithigh_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Ylimithigh_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Zlimitlow_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Zlimitlow_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Zlimithigh_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Zlimithigh_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Alimitlow_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Alimitlow_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Alimithigh_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Alimithigh_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Climitlow_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Climitlow_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Climithigh_edit_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Climithigh_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel38.
function uipanel38_SelectionChangeFcn(hObject, eventdata, handles)


if get(handles.firsttalorinterp_radiobutton, 'value') == 1
    handles.interp.method = 1;
    axes(handles.interp_axes);
    interpfig = imread('һ��̩��.bmp');
    imagesc(interpfig);
    axis off
elseif get(handles.secondtalorinterp_radiobutton, 'value') == 1
    handles.interp.method = 2;
    
    axes(handles.interp_axes);
    interpfig = imread('����̩��.bmp');
    imagesc(interpfig);
    axis off
else
    handles.inter.pmethod = 3;    
end
    


% --- Executes on button press in postprocess_pushbutton.
function postprocess_pushbutton_Callback(hObject, eventdata, handles)
% ������ô������ļ�
dirc = ['..\Data\Output\' datestr(now, 29) ];
if exist([dirc '\postprocess'], 'dir') == 0
    mkdir(dirc, 'postprocess');
end
fnum = 1;
fdir = [dirc '\postprocess\postprocess' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
while(exist(fdir, 'file') ~= 0)
    fnum = fnum + 1;
    fdir = [dirc '\postprocess\postprocess' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
end

% �����Ի���ѡ�񱣴��Ŀ¼���ļ���
[filename, pahtname, filerindex] = uiputfile({'*.txt'}, '�����˳���·���ļ�',  fdir);
try
	% �����ļ�
	wfile = fopen([pahtname filename], 'w+');
catch err
	% ʧ�����׳�������Ϣ
	if pahtname ~= 0
		h = msgbox(err.message, '����ʧ��');
		ah = get( h, 'CurrentAxes' );  
		ch = get( ah, 'Children' );  
		set( ch, 'fontname', '΢���ź�'); 
	end
	return;
end

for i = 1:size(handles.interpresult.mcrarr, 1)
    fprintf(wfile, '%f, %f, %f, %f, %f, %f', handles.interpresult.mcrarr(i, 1), handles.interpresult.mcrarr(i, 2), handles.interpresult.mcrarr(i, 3), handles.interpresult.mcrarr(i, 4), handles.interpresult.mcrarr(i, 5));
    fprintf(wfile, '\n');
end
fclose(wfile);

% --- Executes on button press in showactualjerk_pushbutton.
function showactualjerk_pushbutton_Callback(hObject, eventdata, handles)
% ��������Ծ������
if handles.interp.method == 1
    
elseif handles.interp.method == 2
    figure('units','normalized','position',[0.1,0.1, 0.5, 0.4]);
    
    % ��ʵ�ʵ����Ծ��
    actualjerk = zeros(length(handles.interpresult.actualf) - 2, 1);
    
    for i = 1:length(handles.interpresult.actualf) - 2
        actualjerk(i) = (handles.interpresult.actualf(i + 2) - 2 * handles.interpresult.actualf(i + 1) + handles.interpresult.actualf(i)) / handles.interpolationperiod ^ 2;
    end
    plot((5:length(actualjerk)) * handles.interpolationperiod, actualjerk(5:end), 'linewidth', 1.5);

    h = legend('���ʵ�ʼ��ٶ�');
    set(h,'Orientation','horizon');
    set(gca, 'fontsize', 15);
    ylabel('���ٶ� (mm/s��^2)', 'fontsize', handles.fontsizelabel);
    xlabel('ʱ�� (s)', 'fontsize', handles.fontsizelabel);
    ymax = max(actualjerk(5:end));
    ymin = min(actualjerk(5:end));
    ylim([ymin * 1.1, ymax* 1.3]);
    xlim([0, length(actualjerk) * handles.interpolationperiod]);
    grid on;
else
    
end


% --- Executes on button press in saveinterpresult_pushbutton.
function saveinterpresult_pushbutton_Callback(hObject, eventdata, handles)
% ����岹����֮��������������ʽ����ѡ�����
% ���ҵ�ǰ���ڵ��ļ�����ӱ��ʹ�ļ�������
dirc = ['..\Data\Output\' datestr(now, 29) ];
if exist([dirc '\interpolation'], 'dir') == 0
    mkdir(dirc, 'interpolation');
end
fnum = 1;
fdir = [dirc '\interpolation\interpolation' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
while(exist(fdir, 'file') ~= 0)
    fnum = fnum + 1;
    fdir = [dirc '\interpolation\interpolation' datestr(now, 29) '-' num2str(fnum, 0) '.txt'];
end

% �����Ի���ѡ�񱣴��Ŀ¼���ļ���
[filename, pahtname, filerindex] = uiputfile({'*.txt'}, '�����˳���·���ļ�',  fdir);
try
	% �����ļ�
	wfile = fopen([pahtname filename], 'w+');
catch err
	% ʧ�����׳����������Ϣ
	if pahtname ~= 0
		h = msgbox(err.message, '����ʧ��');
		ah = get( h, 'CurrentAxes' );  
		ch = get( ah, 'Children' );  
		set( ch, 'fontname', '΢���ź�'); 
	end
	return;
end
fprintf(wfile, '% ');
	
if get(handles.interpPoutput_checkbox, 'value') == 1
	fprintf(wfile, '���������͵������� x, y, z, i, j, k ');
end

if get(handles.interpVoutput_checkbox, 'value') == 1
	fprintf(wfile, '�������ٶ� f ');
end

if get(handles.interpAoutput_checkbox, 'value') == 1
	fprintf(wfile, '�����ٶ� a');
end

if get(handles.interpKoutput_checkbox, 'value') == 1
	fprintf(wfile, '������ c');
end
fprintf(wfile, '\n');

% ����ѡ�������Ӧ��txt�ļ�

for i = 1:size(handles.interpresult.interpcor, 1)
	if get(handles.interpPoutput_checkbox, 'value') == 1
		fprintf(wfile, '%f, %f, %f, %f, %f, %f', handles.interpresult.interpcor(i, 1), handles.interpresult.interpcor(i, 2), handles.interpresult.interpcor(i, 3), handles.interpresult.interpcor(i, 4), handles.interpresult.interpcor(i, 6), handles.interpresult.interpcor(i, 7));
	end

	if get(handles.interpVoutput_checkbox, 'value') == 1
		fprintf(wfile, ', %f', handles.interpresult.actualf(i));
	end

	if get(handles.interpPoutput_checkbox, 'value') == 1
		if i == 1
			acc = 0;
		else
			acc = (handles.interpresult.actualf(i) - handles.interpresult.actualf(i - 1)) / handles.interpolationperiod;
		end
		fprintf(wfile, '��%f', acc);
	end

	if get(handles.interpAoutput_checkbox, 'value') == 1
		fprintf(wfile, '��%f', handles.interpresult.curvature(i));
	end
	fprintf(wfile, '\n');
end
fclose(wfile);


function figure1_KeyPressFcn(hObject, eventdata, handles)
% ���ص�һ������������'delete'�����ص���������������л�ͼ
if strcmp(eventdata.Key, 'delete')
	h = findobj('type', 'figure', '-not', 'name', 'FiveAxisVirtualCNCSystem');
	close(h);
end


function uipanel38_CreateFcn(hObject, eventdata, handles)
