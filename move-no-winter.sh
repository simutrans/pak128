mkdir "no-winter"
for dat in *.dat; do 
	if ! grep -Fiq 'backimage[0][0][0][0][0][1]' $dat; then
		if ! grep -Giq 'needs_ground.*=.*1' $dat; then
#			sed -E -i 's|(backimage.*=)|\1\.\./|' $dat
#			printf "chance=0\n" "" >>$dat
			git mv $dat no-winter/
			git mv $(echo "$dat" | sed 's-\.dat$-\.png-') no-winter/
			echo "Dat $dat has no winter"
		fi
	fi
done
