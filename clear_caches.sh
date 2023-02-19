#!/bin/bash
# Bash Script to clear cached memory 
# Oleksii Liaskivskyi

# Get Memory Information
freemem_before=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && freemem_before=$(echo "$freemem_before/1024.0" | bc)
cachedmem_before=$(cat /proc/meminfo | grep "^Cached" | tr -s ' ' | cut -d ' ' -f2) && cachedmem_before=$(echo "$cachedmem_before/1024.0" | bc)

# Output Information
echo -e "This script will clear cached memory and free up your RAM"
echo -e "=========================================================="
echo -e "Free RAM before: $freemem_before MB \nCached memory before: $cachedmem_before MB\n"

# Test sync
if [ "$?" != "0" ]
then
	echo "Something went wrong\nImpossible to sync the filesystem."
	exit 1
fi

# Clear Filesystem Buffer using "sync" and Clear Caches
while true; do
	echo -e "Clear caches? (Yes/No)"
	read -p "" choose_var
	echo -e ""
	case $choose_var in
		[Yy]* )
		echo -e "Clearing caches..."
		sync && echo 3 > /proc/sys/vm/drop_caches
		echo -e "Cleared!"
		echo -e "--------------------------------";
		break
		;;

		[Nn]* )
		echo -e "Exiting"
		exit
		;;

		* )
		echo -e "Please answer 'Yes' or 'No'."
		;;
	esac
done

freemem_after=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && freemem_after=$(echo "$freemem_after/1024.0" | bc)
cachedmem_after=$(cat /proc/meminfo | grep "^Cached" | tr -s ' ' | cut -d ' ' -f2) && cachedmem_after=$(echo "$cachedmem_after/1024.0" | bc)

# Output Summary
echo -e "Free RAM after: $freemem_after MB\nCleared RAM: $(echo "$freemem_after - $freemem_before" | bc) MB"
echo -e ""
echo -e "Cached memory after: $cachedmem_after MB\nCleared caches: $(echo "$cachedmem_before - $cachedmem_after" | bc) MB"

exit 0
