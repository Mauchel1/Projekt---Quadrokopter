% Dieses Skript erzeugt eine GUI, mithilfe derer man via Serieller
% Schnittstelle die Daten des Accelerometers angucken kann. 
%
% Um dieses Skript laufen zu lassen, muss in dem Arduinoprogramm
% "Quadrokopter" NUR der debuggingmodus des Accelerometers
% eingeschaltet sein
%

function varargout = Grafische_Auswertung(varargin)
% GRAFISCHE_AUSWERTUNG MATLAB code for Grafische_Auswertung.fig
%      GRAFISCHE_AUSWERTUNG, by itself, creates a new GRAFISCHE_AUSWERTUNG or raises the existing
%      singleton*.
%
%      H = GRAFISCHE_AUSWERTUNG returns the handle to a new GRAFISCHE_AUSWERTUNG or the handle to
%      the existing singleton*.
%
%      GRAFISCHE_AUSWERTUNG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAFISCHE_AUSWERTUNG.M with the given input arguments.
%
%      GRAFISCHE_AUSWERTUNG('Property','Value',...) creates a new GRAFISCHE_AUSWERTUNG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Grafische_Auswertung_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Grafische_Auswertung_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Grafische_Auswertung

% Last Modified by GUIDE v2.5 23-Jul-2015 01:04:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Grafische_Auswertung_OpeningFcn, ...
                   'gui_OutputFcn',  @Grafische_Auswertung_OutputFcn, ...
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


% --- Executes just before Grafische_Auswertung is made visible.
function Grafische_Auswertung_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Grafische_Auswertung (see VARARGIN)

% Choose default command line output for Grafische_Auswertung
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

Serial_Data = 0;
% UIWAIT makes Grafische_Auswertung wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Grafische_Auswertung_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function AccelDiagramm_aktualisieren(hObject, handles)
s = serial('COM8');
set(s, 'BaudRate', 38400); 
set(s, 'DataBits', 8); 
% set(s, 'FlowControl', 'hardware'); 
% set(s, 'Parity', 'even'); 
% set(s, 'StopBits', 1 ); 
% set(s, 'Terminator', 'CR'); 
% set(s, 'InputBufferSize', 1024); 
i = 1;
    fopen(s); 
    % pause (1);
    % Lesen von der Schnittstelle 
    Serial_Data = fread(s,89); % Hier ist der Müll drin (initialisierung etc.)

while i > 0 

    Serial_Data = fread(s,70); % Hier sind die Daten 

    % S_Data = char(Serial_Data); % zeigt die Daten in ASCII an (als char)
    axes(handles.Accel);
    erste_Daten = find(Serial_Data == 58);  %Das : suchen, danach kommen die neuen Daten
    
    Serial_Data = Serial_Data(erste_Daten(1):70); % Daten anpassen, sodass nach dem ersten Tab auch immer der erste Wert kommt
    
    neue_Daten = find(Serial_Data == 9); % alle tabs raussuchen, nach jedem Tab kommen neue werte

    if (length(neue_Daten) > 6) 
    Data = ([ 
    str2num(char(Serial_Data((neue_Daten(1)+1):(neue_Daten(2)-1)))'), %Accel x
    str2num(char(Serial_Data((neue_Daten(2)+1):(neue_Daten(3)-1)))'), %Accel y
    str2num(char(Serial_Data((neue_Daten(3)+1):(neue_Daten(4)-1)))'), %Accel z
    str2num(char(Serial_Data((neue_Daten(4)+1):(neue_Daten(5)-1)))'), %Gyro x
    str2num(char(Serial_Data((neue_Daten(5)+1):(neue_Daten(6)-1)))'), %Gyro y
    str2num(char(Serial_Data((neue_Daten(6)+1):(neue_Daten(7)-1)))'), %Gyro z
    ])
    end
    plot3([Data(1),0],[Data(2),0],[Data(3),0],'Marker','+','MarkerSize',10); %Accel  (G-Vector)
    hold on;    
    plot3([Data(4),0],[Data(5),0],[Data(6),0],'g','Marker','.','MarkerSize',10); % Gyro
    grid on;
    hold off;
    title('Positionen');
    % xlabel('???');
    % ylabel('?!?');
    xlim([-16384 16384]);
    ylim([-16384 16384]);
    zlim([-16384 16384]);

    set(handles.text1,'String', Data(1)); 
    set(handles.text2,'String', Data(2)); 
    set(handles.text3,'String', Data(3)); 
    
    
    set(handles.text6,'String', Data(1)/16384); %x
    set(handles.text7,'String', Data(2)/16384); %y
    set(handles.text8,'String', Data(3)/16384); %z
    
    winkel1 = atan((Data(3)/16384)/sqrt((Data(2)/16384)^2+(Data(1)/16384)^2));
    winkel2 = atan((Data(2)/16384)/sqrt((Data(3)/16384)^2+(Data(1)/16384)^2));
  
    set(handles.text9,'String', winkel1); 
    set(handles.text10,'String', winkel2); 
    
    set(handles.text11,'String', winkel1*(180/pi)); 
    set(handles.text12,'String', winkel2*(180/pi)); 
    
    i = get(handles.Stop_Slider,'Value');
end
    fclose(s);


% --- Executes on button press in Aktual_button.
function Aktual_button_Callback(hObject, eventdata, handles)
% hObject    handle to Aktual_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AccelDiagramm_aktualisieren(hObject, handles);


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
