e!/bin/bash


echo "--------------------------
User Name: No Chan Kyung
Student Number: 12191597
[ MENU ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item’
3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’
4. Delete the ‘IMDb URL’ from ‘u.item
5. Get the data about users from 'u.user’
6. Modify the format of 'release date' in 'u.item’
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"
stop="N"
until [ $stop = "Y" ]
do
	read -p "Enter your choice [ 1-9] " choice
	case $choice in
	1)
		read -p "Please enter 'movie id'(1~1682):" movie_id
		awk -F "|" -v a=$movie_id '$1==a  {print $0}' u.item
		;;
	2)
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n) :" a2

                case "$a2" in
                         "y")
		  	  	awk -F "|" '$7==1 {if (count < 10) {print $1, $2; count++}}' u.item
                          ;;
                         "n")
                         	echo "You choose 'n'."
                          ;;
                          *)
                            	echo "Invalid choice."
                          ;;
                esac
                ;;
	3)
		read -p "Please enter the 'movie id' (1~1682):" a3
		awk -v a=$a3 'BEGIN { sum = 0 } $2==a { sum += $3; count++ } END { if (count > 0) printf "average rating of %d: %.5f\n", a,  sum / count }' u.data
		;;
	4)	
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y\n) :" a4

                case "$a4" in
                         "y")
			 	sed 's/[^|]*|//5' u.item | head -n 10
                          ;;
                         "n")
                           	echo "You choose 'n'."
                          ;;
                          *)
                         	echo "Invalid choice."
                          ;;
                esac
                ;;
	5)	
		read -p "Do you want to get the data about users from 'u.user'?(y/n):" a5

		case "$a5" in
 			 "y")
			  	head -n 10 u.user | sed 's/|/ /g' | sed 's/ [^ ]*$//' | sed -e 's/M/male/g' -e 's/F/female/g' | sed 's/\(.*\) \(.*\) \(.*\) \(.*\)/user \1 is \2 years old \3 \4/'
  			  ;;
 			 "n")
			  	echo "You choose 'n'."
  			  ;;
			  *)
			  	echo "Invalid choice."
			  ;;
		esac
		;;
	6)
		read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n):" a6
                case "$a6" in
                         "y")
  			    tail -n 10 u.item | sed -e 's/Jan/01/g' -e 's/Feb/02/g' -e 's/Mar/03/g' -e 's/Apr/04/g' -e 's/May/05/g' -e 's/Jun/06/g' -e 's/Jul/07/g' -e 's/Aug/08/g' -e 's/Sep/09/g' -e 's/Oct/10/g' -e 's/Nov/11/g' -e 's/Dec/12/g'|sed -e 's/\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{4\}\)/\3\2\1/g'
                          ;;
                         "n")
                          	echo "You choose 'n'."
                          ;;
                          *)
                          	echo "Invalid choice."
                          ;;
                esac
                ;;
	7)
		read -p "Please enter the ‘user id’(1~943):" user_id
		movie_ids=$(awk -v user_id="$user_id" '$1 == user_id { print $2 }' u.data)
		echo "$movie_ids" | tr ' ' '\n' | sort -n | tr '\n' '|'
		echo -e "\n"	
		echo "$movie_ids" | tr ' ' '\n' | sort -n |  head -n 10 | xargs -I{} awk -F '|' '$1 == {} { print $1 " | " $2 }' u.item	
		;;
	8)
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" a8
	       
	 	case "$a8" in
                         "y")
			 awk -F '|' 'NR == FNR && $2 >= 20 && $2 <= 29 && $4 == "programmer" { age[$1] = 1; next }
             $1 in age { movie_rating[$2] = movie_rating[$2] $3 " "; movie_count[$2]++ }
             END { 
               for (movie_id in movie_rating) {
                 split(movie_rating[movie_id], ratings);
                 sum = 0;
                 for (i = 1; i <= movie_count[movie_id]; i++) {
                   sum += ratings[i];
                 }
                 avg_rating = sum / movie_count[movie_id];
                 printf("%s %.5f\n", movie_id, avg_rating);
               }
             }' FS='|' u.user FS=' ' u.data | sort -n
			  ;;
                         "n")
                         	echo "You choose 'n'."
                          ;;
                          *)
                        	echo "Invalid choice."
                          ;;
                esac
                ;;
	9)
		echo "Bye!"
		stop="Y"
		;;
	esac
done
