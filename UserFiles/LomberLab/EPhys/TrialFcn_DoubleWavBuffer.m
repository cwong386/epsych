function C = TrialFcn_DoubleWavBuffer(C)
% C = TrialFcn_DoubleWavBuffer(C)
%
% Daniel.Stolzberg@gmail.com 2015



global G_DA
 
persistent buffer bufferSize startidx smallBufferSize lastID



if C.tidx == 1 % setup
    lastID = 0;
    startidx = 1;
%     StimFile = 'TEST_DMR.wav';
    StimFile = 'TEST_RAMPS.wav';
    fprintf('Loading stimulus file: ''%s'' ...',StimFile)
    [buffer,Fs] = audioread(StimFile);
    buffer = single(buffer); % double -> single
    buffer = buffer(:)'; % make sure buffer is a row vector
    fprintf(' done\n')
    
    bufferSize = length(buffer);
    
    % It takes ~160 ms to write one second of data at ~100 kHz sampling
    % rate.  
    smallBufferSize = floor(Fs*10); % size of the small buffer
    
    
    % set buffer size
    G_DA.SetTargetVal('Stim.Buffer1Size',smallBufferSize);
    G_DA.SetTargetVal('Stim.Buffer2Size',smallBufferSize);

    
    BufferID = 1;
    
    G_DA.ZeroTarget('Stim.Buffer1Data');
    G_DA.ZeroTarget('Stim.Buffer2Data');

    
else
    
    % Check which buffer is currently playing and write to the other one
    if      G_DA.GetTargetVal('Stim.Buffer1Playing')
        BufferID = 2;
        
    elseif  G_DA.GetTargetVal('Stim.Buffer2Playing')
    	BufferID = 1;
    else
        vprintf(0,1,'NEITHER BUFFER IS PLAYING!')
        error('NEITHER BUFFER IS PLAYING!')
        
    end
end





if lastID == BufferID, return; end % already wrote to this buffer


if startidx + smallBufferSize > bufferSize
    smallBufferSize = bufferSize - startidx;
    
    % reset buffer size
    G_DA.SetTargetVal(sprintf('Stim.Buffer%dSize',BufferID),smallBufferSize);
end


% write next small buffer while the other one is playing
e = G_DA.WriteTargetVEX(sprintf('Stim.Buffer%dData',BufferID), ...
    0, 'F32', buffer(startidx:startidx+smallBufferSize-1));

if e
    vprintf(2,'Trigger index % 5d updated BufferID %d from % 9d to % 9d', ...
        C.tidx,BufferID,startidx,startidx+smallBufferSize-1)
else
    vprintf(0,1,'Unable to update BufferID %d',BufferID)
    error('Unable to update BufferID %d\n',BufferID)
end





startidx = startidx + smallBufferSize;

lastID = BufferID;


if C.tidx == 1   
    G_DA.SetTargetVal('Stim.Enable1',1);

    G_DA.SetTargetVal('Stim.StartPlaying',1);
    pause(0.001);
    G_DA.SetTargetVal('Stim.StartPlaying',0);
    

    G_DA.SetTargetVal('Stim.Enable2',1);
    
end

















