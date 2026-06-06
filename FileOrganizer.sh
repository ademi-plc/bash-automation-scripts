#!/bin/sh
mkdir -p images docs others
for file in * ; do
	[ -f "$file" ] || continue
	ext=$(echo "$file" | tr '[:upper:]' '[:lower:]')
	ext="${ext##*.}"
	case "$ext" in
		jpg|jpeg|png|gif|bmp|svg|webp)
			dest="images"
			;;
		txt|pdf|doc|docx|docs|odt|xls|xlsx|csv|md)
			dest="docs"
			;;
		*)
			dest="others"
			;;
	esac
	echo "Moving: $file -> $dest/"
	mv "$file" "$dest/"
done
echo "Done!"
