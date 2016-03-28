%% Flip Checkerboards
% Sends 1 ms pulse from from Bits# TrigOut to TDT digital input on every
% Checkerboard flip.
%
% DJS 3/2016

nFlips = 100; % # flips
IFI = 1; % inter-flip interval (seconds)

nCheckers = 10;

ScreenNum = 0;

Screen('Preference', 'SkipSyncTests', 0);

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'ClampOnly'); 
PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');

Priority(1);

rc = PsychGPUControl('SetGPUPerformance',10);

[window,ScreenRect] = PsychImaging('OpenWindow',ScreenNum,0.5);

HideCursor(window);

black = BlackIndex(window);
white = WhiteIndex(window);



% Create a new chckerboard based on the current stimulus parameters
chksize = round(ScreenRect(3)/(nCheckers*2));

% Reverse the checkerboard on each presentation
chk = [ones(chksize) zeros(chksize)];
Check = repmat([chk; fliplr(chk)],nCheckers,nCheckers);
Check = Check * white;
Check(~Check) = Check(~Check) * black;
CheckTex{1} = Screen('MakeTexture',window,Check,[],[],2);

chk = [zeros(chksize) ones(chksize)];
Check = repmat([chk; fliplr(chk)],nCheckers,nCheckers);
Check = Check * white;
Check(~Check) = Check(~Check) * black;
CheckTex{2} = Screen('MakeTexture',window,Check,[],[],2);


WaitSecs(10); % wait a bit before running


vbl = Screen('Flip',window); % get starting timestamp

vblTimestamps = vbl+(1:IFI:(nFlips)*IFI);

% run 
for i = 1:nFlips
    BitsTrigger(window,vblTimestamps(i));
    
    Screen('DrawTexture',window,CheckTex{1+mod(i,2)});
    vbl = Screen('Flip',window,vblTimestamps(i));
end

sca

disp('done');




















