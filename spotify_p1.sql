CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
--1.Retrieve the names of all tracks that have more than 1 billion streams.--
select count(track) from spotify where stream >= 1000000000;
--2.List all albums along with their respective artists.--
select artist,album from spotify;
--3.Get the total number of comments for tracks where licensed = TRUE.--
select count(comments) from spotify where licensed = true;
--4.Find all tracks that belong to the album type single.--
select track from spotify where album_type = 'single';
--5.Count the total number of tracks by each artist.--
select distinct(artist),count(track) as cnt_track from spotify group by artist order by cnt_track desc;
--6.Calculate the average danceability of tracks in each album.--
select avg(danceability),track from spotify group by 2;
--7.Find the top 5 tracks with the highest energy values.--
select distinct(track),energy_liveness from spotify where energy_liveness is not null order by  2 desc limit 5;
--8.List all tracks along with their views and likes where official_video = TRUE.--
select distinct(track),views,likes from spotify where official_video = 'true' ;
--9.For each album, calculate the total views of all associated tracks.--
select distinct album,track,views from spotify;
--10.Retrieve the track names that have been streamed on Spotify more than YouTube.--
SELECT 
    track,
    SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END) AS spotify_streams,
    SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END) AS youtube_streams
FROM spotify GROUP BY track
HAVING SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END) 
     > SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END)
ORDER BY spotify_streams desc;
--11.Find the top 3 most-viewed tracks for each artist using window functions.--
select artist,track,views from 
(select *, rank() over (partition by artist order by views desc) as rank from spotify
) as ranked where rank<=3 order by artist,rank;
--12.Write a query to find tracks where the liveness score is above the average.--
select track,liveness from spotify where liveness> (select avg(liveness) from spotify);
--13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.--
with t1 as 
(select album, max(energy) as max_energy,min(energy) as min_energy from spotify group by 1)
select album,max_energy-min_energy as energy_diff from t1 ;
--14.Find tracks where the energy-to-liveness ratio is greater than 1.2--
select track,(energy/liveness) as ratio from spotify where liveness !=0 and (energy/liveness)>1.2;
--15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.--
select track,views, sum(likes) over (partition by track ) as cumulative_sum from spotify order by views desc;
--16. Find the track(s) with the maximum number of likes in each channel.--
select track,channel,likes from (
select*, rank() over (partition by channel  order by likes desc) as rnk from spotify) as t where rnk=1 order by likes desc;
--17. Rank tracks by energy within each artist.--
select track,artist,energy,rank() over (partition by artist order by energy desc) as rnk from spotify;
--18. Find tracks where the duration is greater than the average duration of their channel.--
select artist,track from spotify 
where duration_min>(select avg(duration_min) from spotify s2 where s2.channel = spotify.channel) group by spotify.artist,spotify.track,spotify.duration_min;

select * from spotify;


