#!/bin/bash
#
# This is an ugly workaround to accomodate the folder structure of EMM Cell.
# splattr wants relative or full paths to input files, but only splat filenames
# and srcdirs are passed properly to ulam unless the ulam files are in the default
# path for ulam, '.'
# This could be fixed either supporting full/relative paths as ulam arguments
# instead of:
# --sd './path' Foo.ulam
# or by parsing ulam file paths into the above format with splattr.
#
# All of this has me thinking that it would be best not to include the pieces
# of C211-Membrane I need in my source code at all, and instead have a package
# manager like pip or cpan that handles Ulam and SPLAT dependencies and puts
# packages in a location that's crawled by splattr by default, but this
# doesn't really affect the above issue.
#

MFZ=EMM-Cell.mfz

for f in $(find . -name '*.ulam' -type f| grep -v '.splatgen'); do
    FILES+=$(printf '%s ' $f);
done
for f in $(find . -name '*.splat' -type f); do
    FILES+=$(printf '%s ' $f);
done
# Let splattr generate the ulam code and call ulam with malformed options.
ULAM=$(which ulam)
SPLATTR=$(which splattr)
$SPLATTR $FILES 2>/dev/null

DIRS="--sd /usr/bin/vendor_perl/lib --sd /usr/share/perl5/vendor_perl/auto/share/dist/App-Splattr"
for dir in $(find . -type d); do
    issourcedir=0
    for f in $(ls $dir | grep '.ulam$'); do
	issourcedir=1
	ULAM_FILES+=$(printf '%s ' $f)
    done
    if [ $issourcedir -eq 1 ]; then
        DIRS+=$(printf " --sd %s" $dir)
    fi
done
# then call ulam with properly-formatted options.
printf '#\n# Calling ulam function: \n#\n\n'
printf '%s %s %s %s \n' 'ulam' $DIRS $MFZ $ULAM_FILES
printf '\n'
$ULAM --no-std $DIRS $MFZ $ULAM_FILES
