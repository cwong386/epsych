function disabledropdown_SanesLab(h,dev,param)
%Custom function for SanesLab epsych
%
%This function disables the dropdown button if the parameter is roved, or
%if the parameter tag does not exist in the circuit.
%
%Inputs:
%   h: handles of dropdown menu
%   dev: index of TDT device (i.e. which circuit should we look at?)
%   param: parameter tag string
%
%Example usage: disabledropdown(handles.freq,handles.dev,'Freq')
%
%Written by ML Caras 7.24.2016


global ROVED_PARAMS RUNTIME

%Tag name in RPVds
tag = param;

%Rename parameter for OpenEx Compatibility
if RUNTIME.UseOpenEx
    param = ['Behavior.' param];
end

%Disable dropdown if it is a roved parameter, or if it's not a
%parameter tag in the circuit
if ~isempty(cell2mat(strfind(ROVED_PARAMS,param)))  | ...
        isempty(find(ismember(RUNTIME.TDT.devinfo(dev).tags,tag),1))
    set(h,'enable','off');
end