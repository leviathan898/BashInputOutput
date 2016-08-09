#!/bin/bash

exec 10<&0

rm -rf output

if [ ! -d "output" ]; then
	mkdir output
fi

for d in $(ls input); do
	if [ -d "input/$d" ]; then
		for m in $(ls input/$d); do
			M="${m%.txt}"
			exec < "input/$d/$m"
			while read LINE; do
				A=($LINE)
				directory="output/${A[0]}"
				if [ ! -d $directory ]; then
					mkdir $directory
				fi
				touch "$directory/$d.txt"
				echo $M ${A[1]} >> "$directory/$d.txt"
				touch "$directory/Notes.txt"
				touch "$directory/Notes1.txt"
				if [ ${A[1]} -lt 40 ]; then
					echo $M >> "$directory/Notes1.txt"
				fi
				touch "$directory/Details.txt"
			done
		done
	fi
done

for s in $(ls input); do
	if [ -f "input/$s" ]; then
	exec < "input/$s"
		while read LINE; do
			B=($LINE)
			for c in $(ls output); do
				if [ ${B[0]} == $c ]; then 
					echo Surname: "${B[1]}" >> "output/$c/Details.txt"
					echo Name: "${B[2]}" >> "output/$c/Details.txt"
					echo Date of Birth: "${B[3]}" >> "output/$c/Details.txt"
					echo Address: "${B[*]:4}" >> "output/$c/Details.txt"
					echo "Failed:" >> "output/$c/Notes.txt"
					cat "output/$c/Notes1.txt" >> "output/$c/Notes.txt"
					rm "output/$c/Notes1.txt"
				fi
			done
		done
	fi
done
