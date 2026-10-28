#!/bin/bash
set -e

# Define the container name
NAMES="blobstore-list blobstore-copy oddm-workflow-sink oddm-api-app oddm-api-process"
BROKERS="rabbit kafka"

# Temporary file to store package versions
temp_file="ghcr_prune.ids"
echo "Fetching untagged images from GHCR..."
for BROKER in $BROKERS
do
	for NAME in $NAMES
	do
		CONTAINER="$NAME-$BROKER"
		echo "Checking $CONTAINER"
		set +e
		rm -rf $temp_file
		echo "temp_file=$temp_file"
		gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /users/infosmid-org/packages/container/$CONTAINER/versions --paginate > $temp_file
		RC=$?
		set -e
		if [ "$RC" == "0" ]; then
			ids_to_delete=$(cat "$temp_file" | jq -r '.[] | select(.metadata.container.tags==[]) | .id')
			if [ "${ids_to_delete}" != "" ]
			then
				echo "Deleting untagged images for $CONTAINER"
				while read -r id
				do
					if [ -n "$id" ]; then
						echo "Deleting untagged $CONTAINER image with ID $id..."
						# Handle potential 404 error gracefully
						set +e
						gh api --method DELETE -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /users/infosmid-org/packages/container/$CONTAINER/versions/${id} --input - > /dev/null 2>&1
						RC_DEL=$?
						set -e
						if [ "$RC_DEL" == "0" ]; then
							echo "Deleted untagged $CONTAINER image with ID $id."
						elif [ "$RC_DEL" == "1" ]; then
							# Often gh api returns 1 for 404, need to check if we can get more info or just warn
							echo "::warning ::Failed to delete untagged $CONTAINER image with ID $id. It may have already been deleted."
						else
							echo "::warning ::Unexpected error (exit code $RC_DEL) deleting image ID $id."
						fi
					fi
				done <<< "$ids_to_delete"
				echo "All untagged images have been deleted successfully."
			fi
			rm -rf $temp_file
		fi
	done
done
