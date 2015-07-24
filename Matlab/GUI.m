function varargout = GUI(varargin)
%GUI M-file for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('Property','Value',...) creates a new GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI('CALLBACK') and GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 23-Jul-2015 21:35:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Zeugs initialisieren
set(handles.Schub_Slider,'Value', 0); 
set(handles.Drehung_Slider,'Value', 0); 
set(handles.Nicken_Slider,'Value', 0); 
set(handles.Kippen_Slider,'Value', 0); 

set(handles.Schub_Wert,'String', 0); 
set(handles.Drehung_Wert,'String', 0); 
set(handles.Nicken_Wert,'String', 0); 
set(handles.Kippen_Wert,'String', 0); 
Diagramm1_aktualisieren(hObject, handles);
Diagramm2_aktualisieren(hObject, handles);


% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Schub_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Schub_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mein Zeug
Schub = get(hObject,'Value'); 
set(handles.Schub_Wert,'String', Schub); 
Diagramm1_aktualisieren(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Schub_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Schub_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Kippen_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Kippen_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mein Zeug
Kippen = get(hObject,'Value'); 
set(handles.Kippen_Wert,'String', Kippen); 
Diagramm2_aktualisieren(hObject, handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Kippen_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kippen_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Nicken_Slider_Callback(hObject, ~, handles)
% hObject    handle to Nicken_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mein Zeug
Nicken = get(hObject,'Value'); 
set(handles.Nicken_Wert,'String', Nicken); 
Diagramm2_aktualisieren(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Nicken_Slider_CreateFcn(hObject, ~, ~)
% hObject    handle to Nicken_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Drehung_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Drehung_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mein Zeug
Drehung = get(hObject,'Value'); 
set(handles.Drehung_Wert,'String', Drehung); 
Diagramm1_aktualisieren(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Drehung_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Drehung_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on key press with focus on Drehung_Slider and none of its controls.
function Drehung_Slider_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Drehung_Slider (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Schub_Reset.
function Schub_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Schub_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Schub_Slider,'Value', 0); 
set(handles.Schub_Wert,'String', 0); 
Diagramm1_aktualisieren(hObject, handles);

% --- Executes on button press in Kippen_Reset.
function Kippen_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Kippen_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Kippen_Slider,'Value', 0); 
set(handles.Kippen_Wert,'String', 0); 
Diagramm2_aktualisieren(hObject, handles)

% --- Executes on button press in Drehung_Reset.
function Drehung_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Drehung_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Drehung_Slider,'Value', 0); 
set(handles.Drehung_Wert,'String', 0); 
Diagramm1_aktualisieren(hObject, handles);

% --- Executes on button press in Nicken_Reset.
function Nicken_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Nicken_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Nicken_Slider,'Value', 0); 
set(handles.Nicken_Wert,'String', 0); 
Diagramm2_aktualisieren(hObject, handles)

function Diagramm1_aktualisieren(hObject, handles)
axes(handles.Diagramm1);
plot(get(handles.Drehung_Slider,'Value'),get(handles.Schub_Slider,'Value'),'Marker','*','MarkerSize',10,'Color','r'); 
hold on;
plot(get(handles.Drehung_Slider,'Value'),get(handles.Schub_Slider,'Value'),'Marker','o','MarkerSize',10,'Color','r'); 
% grid on;
hold off;
title('Positionen');
xlabel('Drehung');
ylabel('Schub');
xlim([-90 90]);
ylim([0 1023]);
Serial_Send(hObject, handles);

function Diagramm2_aktualisieren(hObject, handles)
axes(handles.Diagramm2);
plot(get(handles.Kippen_Slider,'Value'),get(handles.Nicken_Slider,'Value'),'Marker','+','MarkerSize',10); 
hold on;
plot(get(handles.Kippen_Slider,'Value'),get(handles.Nicken_Slider,'Value'),'Marker','o','MarkerSize',10); 
% grid on;
hold off;
title('Positionen');
xlabel('Kippen');
ylabel('Nicken');
xlim([-90 90]);
ylim([-90 90]);
Serial_Send(hObject, handles);

function Serial_Send(hObject, handles)
% Schreiben an die Schnittstelle 
s = serial('COM8');
set(s, 'BaudRate', 38400); 
set(s, 'DataBits', 8); 
% set(s, 'FlowControl', 'hardware'); 
% set(s, 'Parity', 'even'); 
% set(s, 'StopBits', 1 ); 
% set(s, 'Terminator', 'CR'); 
% set(s, 'InputBufferSize', 1024); 

if (get(handles.Stop_Slider,'Value') == 1) %% wenn Serial an
    fopen(s); 
    set(handles.text15,'String', 'AN');   
    fwrite(s, round(get(handles.Schub_Slider,'Value')), 'uint8'); %hinschreiben
    set(handles.text10,'String', (round(get(handles.Schub_Slider,'Value'))));
    set(handles.text12,'String', fread(s,3));  % zurücklesen
    fclose(s); 
    delete(s);
    clear s;
    set(handles.text15,'String', 'AUS');   
end

% --- Executes on slider movement.
function Stop_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
   

% --- Executes during object creation, after setting all properties.
function Stop_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stop_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
