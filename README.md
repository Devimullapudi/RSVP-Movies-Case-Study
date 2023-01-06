# RSVP-Movies-Case-Study
# Problem Introduction:
RSVP Movies is an Indian film production company which has produced many super-hit movies. They have usually released movies for the Indian audience but for their next project, they are planning to release a movie for the global audience in 2022.

 
# ERD:
The production company wants to plan their every move analytically based on data and have approached you for help with this new project. You have been provided with the data of the movies that have been released in the past three years. We have to analyse the data set and draw meaningful insights that can help them start their new project. 


table	column											
movie	id								genre			ratings
movie	title								* movie_id			* movie_id
movie	year								* genre			avg_rating
movie	date_published											total_votes
movie	duration											median_rating
movie	country											
movie	worlwide_gross_income											
movie	languages								movie			
movie	production_company								* id			
genre	movie_id								title			
genre	genre								year			
director_mapping	movie_id								date_published			
director_mapping	name_id					role_mapping			duration			director_mapping
role_mapping	movie_id					* movie_id			country			* movie_id
role_mapping	name_id					* name_id			worlwide_gross_income			* name_id
role_mapping	category					category			languages			
names	id								production_company			
names	name											
names	height								names			
names	date_of_birth								* id			
names	known_for_movies								name			
ratings	movie_id								height			
ratings	avg_rating								date_of_birth			
ratings	total_votes								known_for_movies			
ratings	median_rating											
