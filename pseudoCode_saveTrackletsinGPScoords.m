

base_dir = '/home/skhokhar/common/people/skhokhar/KITTI/unzipped/cityUnzipped/synced/2011_09_26_drive_0001_sync/';
tracklet_dir = '/home/skhokhar/common/people/skhokhar/KITTI/unzipped/cityUnzipped/tracklets/2011_09_26_drive_0001_tracklets/2011_09_26/2011_09_26_drive_0001_sync';

gpsEgo = computePose_salman(base_dir); % ego vehicles data (long, lat, alt, bearing, bearing in GIS standard)

% Load tracklets for clip

tracklets = readTrackletsMex([tracklet_dir '/tracklet_labels.xml']);

% For each frame, compute GPS positions of all tracklets in frame

for iFrame = 1:size(gpsEgo,1) % loop over frames in video
    for iTracklet = 1:length(tracklets) % loop over all tracklets
                
         % if the following if condition is TRUE, then tracklet exists in current frame
        if iFrame > tracklets{iTracklet}.first_frame && iFrame <= tracklets{iTracklet}.first_frame + size(tracklets{iTracklet}.poses,2)
            
           % compute GPS coords for tracklet in this frame, we are given
           % ego cars GPS and tracked cars relative position

           % idx_tracklet: index at which to store new GPS Data for tracklet (dont confuse with index for tracklets, i-e iTracklet)            
           % bearing     : bearing of EGO car in GIS standard
           % dist        : distance of tracked car from EGO car
           
           idx_tracklet = iFrame - tracklets{iTracklet}.first_frame; 
           bearing = gpsEgo(iFrame, end); 
           % ego car bearing + angle to measured car = bearing of distance travelled to new location
           % input needed by computeRelativeAngle : vector from ego car to tracked car in current frame 
           bearing = bearing + computeRelativeAngle(tracklets{iTracklet}.poses(1:2,idx_tracklet)); 
           if bearing > 2*pi
               bearing = 2*pi - bearing;
           end
           dist = sqrt((tracklets{iTracklet}.poses(1,idx_tracklet))^2 + (tracklets{iTracklet}.poses(1:2,idx_tracklet))^2);
           temp = computeGPSgivenRefGPSDistBearing(gpsEgo(iFrame,1:3), bearing, dist); % temp has GPS coo
           tracklets{iTracklets}.gpsTrack = [tracklets{iTracklets}.gpsTrack temp];
            
        end
        
    end
    
end
            
            