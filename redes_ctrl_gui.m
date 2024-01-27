function check=redes_ctrl_gui(check)
%       redes_ctrl_gui.m
%********************************************************************
% Written by Alicia Zinnecker (N&R Engineering) and Jeffrey Csank (NASA)
% NASA Glenn Research Center, Cleveland, OH
% May 2013
%
% This file prompts the user to specify which, if any, part of the loaded
% controller should be re-designed using the generic engine control module.
%********************************************************************
close all;

%--------------------------------
% Configure the GUI window
%--------------------------------
S.fh = figure('units','normalized',...
    'position',[.1 .2 .2 .2],...
    'menubar','none',...
    'name','TTECTrA: Controller Redesign Selection',...
    'numbertitle','off',...
    'visible','off',...
    'resize','on');

S.panel1 = uipanel('units','normalized',...
    'pos',[.01 .01 .98 .98],...
    'fontsize',12,...
    'TitlePosition', 'centertop');

%------ Controller Component Panel ------
S.chklab = uicontrol(S.panel1,...
    'style','text',...
    'unit','normalized',...
    'position',[0.01 0.9 0.9 0.1],...
    'HorizontalAlignment','center',...
    'fontsize',12,...
    'String','Select which parts of the controller to re-design:');

S.SP_box = uicontrol(S.panel1,...
    'style','checkbox',...
    'unit','normalized',...
    'position',[0.25 0.7 0.5 0.17],...
    'HorizontalAlignment','left',...
    'fontsize',10,...
    'backgroundcolor',[0.95 0.95 0.95],...
    'String','Setpoint calculation');

S.ctrl_box = uicontrol(S.panel1,...
    'style','checkbox',...
    'unit','normalized',...
    'position',[0.25 0.5 0.5 0.17],...
    'HorizontalAlignment','left',...
    'fontsize',10,...
    'backgroundcolor',[0.95 0.95 0.95],...
    'String','Controller gain calculation');

S.lim_box = uicontrol(S.panel1,...
    'style','checkbox',...
    'unit','normalized',...
    'position',[0.25 0.3 0.5 0.17],...
    'HorizontalAlignment','left',...
    'fontsize',10,...
    'backgroundcolor',[0.95 0.95 0.95],...
    'String','Limit schedule calculation');

S.gobtn = uicontrol(S.panel1,...
    'style','push',...
    'unit','normalized',...
    'position',[.25 .1 .5 .15],...
    'fontsize',10,...
    'string','Continue',...
    'enable', 'on',...
    'callback',{@go_call,S});

set(S.fh,'closerequestfcn',@close_gui_call)

%--- force design of components not present in the loaded controller
if check(4)==0
    set(S.SP_box,'Value',1,'Enable','off');     % force calculation of setpoints
end

if check(5)==0
    set(S.ctrl_box,'Value',1,'Enable','off');   % force design of controller gains
end

if check(6)==0
    set(S.lim_box,'Value',1,'Enable','off');    % force calculation of limit schedules
end

%--- move and show gui
movegui(S.fh,'center');
set(S.fh,'visible','on'); % Make the GUI visible.

uiwait;

%--------------------------------
% Callbacks for user interactions with GUI
%--------------------------------
    function varargout = go_call(varargin)
        %----------------------------------------------------
        % Callback for Loading Data File
        %----------------------------------------------------
        check(4) = ~get(S.SP_box,'value');
        check(5) = ~get(S.ctrl_box,'value');
        check(6) = ~get(S.lim_box,'value');
        
        close(S.fh);
    end

    function close_gui_call(src,evnt)
        %----------------------------------------------------
        % Callback for Closing GUI
        %----------------------------------------------------
        if ~exist('check','var')
            check=zeros(1,6);   % force complete control design if window is closed and check doesn't exist
        end
        
        delete(gcf);
    end
end