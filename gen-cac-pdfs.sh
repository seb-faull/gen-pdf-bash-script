#!/bin/bash
# Generate PDFs for selected offices


# The input file that caontains the required data (list of offices)
infile='/home/Users/sfaull/dev/xxxx/data/log/offices.txt'

# The output dir to store the logs
outdir='/home/Users/sfaull/dev/xxxx/data/log/'

# Synapse automation script directory
scriptdir='/home/Users/sfaull/dev/dev_proj/scripts/automation'




# Command
phpcmd=(php -d memory_limit=1500M automator.php --namespace="automation\operations\it\agent_process\process" --run --year=2018 --verbose)


# check whether script dir exists
if [[ ! -d "$scriptdir" ]]; then
    echo "Error: Selected '$scriptdir' directory does not exist."
    exit 1
fi

# check whether output dir exists
if [[ ! -d "$outdir" ]]; then
    echo "Error: Selected '$outdir' directory does not exist."
    exit 1
fi

# check whether input file exists
if [[ ! -e "$infile" ]]; then
    echo "Error: Selected '$infile' file does not exist."
    exit 1
fi


cd "$scriptdir"



oldifs=$IFS


echo -e "Generating PDFs from file: $infile"
echo -e "Putting log files into directory: $outdir\n"


# Read input file and fire up PDF generation per office
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [ "$line" != "" ]; then
	echo -e "Processing office: $line"

	# Creating PDFs
	"${phpcmd[@]}" "--office=$line" > "$outdir/$line-log.txt"
    fi
done < "$infile"


IFS=$oldifs


echo -e "\nGeneration of PDFs has been finished.\n"


