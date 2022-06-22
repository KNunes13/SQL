#Total number of shows and movies, unspecified#
select count(mov_title) from movies 
union
select count(show_title) from shows;

#Total numbers of movies and shows watched#
select count(mov_title) from movies where mov_watched = 'yes'
union
select count(show_title) from shows where not last_watched = 'dnf';

#Every actor in any show/movie#
select actor_name, mov_title, show_title from actors
join cast on cactor_id = actor_id
left join movies on mov_id = cmov_id
left join shows on show_id = cshow_id
group by actor_id;

#Most listed actors in database, not specifying watched#
select actor_name, count(cactor_id) as freq
from cast
join actors on actor_id = cactor_id
group by actor_id
having freq >10
order by freq DESC;

#Every director#
Select mov_title, dir_name, show_title FROM movies
join media_directors as md
on md.mov_id = movies.mov_id
left join directors d on d.dir_id = md.dir_id
left join shows s on s.show_id = md.show_id
group by md.dir_id;

#List of jobs worked on by directors#
Select dir_name, mov_title, show_title from directors d
join media_directors md on md.dir_id = d.dir_id
left join movies m on m.mov_id = md.mov_id
left join shows s on s.show_id = md.show_id
where dir_name like '%K%'
group by md.mov_id;

#all directors with more than one job#
select d.dir_name, count(md.dir_id) as freq
from directors as d
join media_directors md on md.dir_id = d.dir_id
group by md.dir_id
having freq > 2
order by freq desc;

#Every role an actor has played#
select distinct actor_name, role, show_title, mov_title from cast
join actors on actor_id = cactor_id
left join shows s on s.show_id = cshow_id
left join movies m on m.mov_id = cmov_id
group by idcast;
#specify by actor name : #
select distinct actor_name, role, show_title, mov_title from cast
join actors on actor_id = cactor_id
left join shows s on s.show_id = cshow_id
left join movies m on m.mov_id = cmov_id
where actor_name like '%pip%'
group by idcast;


#Actors and their roles for all movies and shows they were in#
select actor_name, role, show_title, mov_title from actors 
join cast on cactor_id = actor_id
left join shows s on s.show_id=cshow_id
left join movies m on m.mov_id =cmov_id
where cshow_id is not null and cmov_id is not null;

#Most watched directors# 
select dir_name, count(md.dir_id) as freq
from directors d
join media_directors md on md.dir_id = d.dir_id
left join movies m on m.mov_id = md.mov_id
left join shows s on s.show_id = md.show_id
where mov_watched = 'yes' or not last_watched = 'dnf'
group by md.dir_id
having freq >= 5
order by freq desc;

#Most watched actors#
Select actor_name, count(cactor_id) as freq
from cast
join actors on actor_id = cactor_id
left join movies on mov_id = cmov_id
left join shows on show_id = cshow_id
where mov_watched = 'yes' OR NOT last_watched = 'dnf'
group by cactor_id
having freq >=10
order by freq asc;

#Shows and movies that were DNF'd#
select mov_title as title, mov_rating as rating from movies
where mov_watched like '%dnf%'
union
select show_title, show_rating from shows
where last_watched like '%dnf%';

#genres of movies and shows that were DNF'd#
select g.genre, show_title, mov_title from genres g
join media_genres mg on mg.genre_id = g.genre_id
left join shows s on s.show_id = mg.show_id
left join movies m on m.mov_id = mg.mov_id
where last_watched like '%dnf%' or mov_watched like '%dnf%'
group by mg.id
order by mg.id;

#Most common genres in database#
select g.genre_id, count(g.genre_id) as freq, g.genre
from media_genres as mg
join genres g on g.genre_id = mg.genre_id
group by mg.genre_id order by freq desc;

#Find most watched genres between movies and shows#
select g.genre_id, count(g.genre_id) as freq, g.genre
from media_genres as mg
join genres g on g.genre_id = mg.genre_id
left join movies m on m.mov_id = mg.mov_id
left join shows s on s.show_id = mg.show_id
where mov_watched = 'yes' or not last_watched = 'dnf'
group by mg.genre_id ORDER BY freq DESC;


