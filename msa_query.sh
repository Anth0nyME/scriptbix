#!/bin/bash
# set -x
# Version 1.1 (01.08.2018)
# mad@starokashirka.ru
if [ "$5" = "" ]; then
clear
printf "Usage: address port login pasword target [and target number to get xml output]\n\n"
printf "Supported targets:\nsystem, versions, controllers, power-supplies, ports, fans, pools, hosts,\ndisks, disk-statistics, vdisks, vdisk-statistics, volumes, volume-statistics,\ndisk-groups, disk-group-statistics\n\n"
printf "Note: not all targets are supported by ALL MSA models, so you need to query it\n"
exit
fi

msa_addr=$1
msa_port=$2
msa_login=$3
msa_passwd=$4
msa_target=$5
object_xml_block='{#HP_MSA_BLOCK}'
object_target_id='{#HP_MSA_TARGET}'

if [ "$5" = "ports" ]; then
string_filter_1='basetype="port".*oid="'
string_filter_2='PROPERTY.name="port"'
target_str_grep=$(printf '"[0-9]*"\\|>[A-B][0-9]<')

elif [ "$5" = "disk-statistics" ]; then
string_filter_1='basetype="disk-statistics".*oid="'
string_filter_2='PROPERTY.name="location"'
target_str_grep=$(printf '[0-9].[0-9]*')

elif [ "$5" = "disks" ]; then
string_filter_1='basetype="drives".*oid="'
string_filter_2='PROPERTY.name="location"'
target_str_grep=$(printf '[0-9].[0-9]*')

elif [ "$5" = "vdisks" ]; then
string_filter_1='basetype="virtual-disks".*oid="'
string_filter_2='PROPERTY.name="name"'
target_str_grep=$(printf '"[0-9]*"\\|>.*[0-9]*<')

elif [ "$5" = "power-supplies" ]; then
string_filter_1='basetype="power-supplies".*oid="'
string_filter_2='PROPERTY.name="durable-id"'
target_str_grep=$(printf '"[0-9]*"\\|>.*<')
target_str_gsub="{gsub(\"[a-z]*_\", \"\"); print}"

elif [ "$5" = "enclosures" ]; then
string_filter_1='enclosures".*oid="'
string_filter_2='PROPERTY.name="enclosure-id"'
target_str_grep=$(printf '"[0-9]*"\\|>[0-9]<')

elif [ "$5" = "volumes" ]; then
string_filter_1='basetype="volumes".*oid="'
string_filter_2='PROPERTY.name="volume-name"'
target_str_grep=$(printf '"[0-9]*"\\|>.*[0-9A-Za-z]*<')

elif [ "$5" = "volume-statistics" ]; then
string_filter_1='basetype="volume-statistics".*oid="'
string_filter_2='PROPERTY.name="volume-name"'
target_str_grep=$(printf '"[0-9]*"\\|>.*[0-9A-Za-z]*<')

elif [ "$5" = "disk-groups" ]; then
string_filter_1='basetype="disk-groups".*oid="'
string_filter_2='PROPERTY.name="name"'
target_str_grep=$(printf '"[0-9]*"\\|>.*[0-9A-Za-z]*<')

elif [ "$5" = "disk-group-statistics" ]; then
string_filter_1='basetype="disk-group-statistics".*oid="'
string_filter_2='PROPERTY.name="name"'
target_str_grep=$(printf '"[0-9]*"\\|>.*[0-9A-Za-z]*<')

elif [ "$5" = "hosts" ]; then
string_filter_1='basetype="hosts".*oid="'
string_filter_2='PROPERTY.name="host-name"'
target_str_grep=$(printf '"[0-9]*"\\|>.*[0-9A-Za-z]*<')

elif [ "$5" = "controllers" ]; then
string_filter_1='basetype="controllers".*oid="'
string_filter_2='PROPERTY.name="controller-id-numeric"'
target_str_grep=$(printf '"[0-9]*"\\|>[0-9]*<')

elif [ "$5" = "system" ]; then
string_filter_1='basetype="system".*oid="'
string_filter_2='PROPERTY.name="system-name"'
target_str_grep=$(printf '"[0-9]*"\\|>[0-9A-Za-z-]*<')

elif [ "$5" = "versions" ]; then
string_filter_1='basetype="versions".*oid="'
string_filter_2='name="[a-z]*-.-[a-z]*"'
target_str_grep=$(printf '[0-9]')
target_str_gsub="{gsub(\"[a-z]*-a-[a-z]*\", \"1\"); gsub(\"[a-z]*-b-[a-z]*\", \"0\"); print}"
target_str_sort=true

elif [ "$5" = "vdisk-statistics" ]; then
string_filter_1='basetype="vdisk-statistics".*oid="'
string_filter_2='PROPERTY.name="name"'
target_str_grep=$(printf '"[0-9]*"\\|>[0-9A-Za-z-]*<')

elif [ "$5" = "pools" ]; then
string_filter_1='basetype="pools".*oid="'
string_filter_2='PROPERTY.name="name"'
target_str_grep=$(printf '"[0-9]*"\\|>[0-9A-Za-z-]*<')

elif [ "$5" = "fans" ]; then
string_filter_1='basetype="fan".*oid="'
string_filter_2='PROPERTY.name="durable-id"'
target_str_grep=$(printf '"[0-9]*"\\|>.*<')
target_str_gsub="{gsub(\"[a-z]*_\", \"\"); print}"

fi
    if [ -z "$target_str_gsub" ]; then
    target_str_select=$(printf "/$string_filter_1|$string_filter_2/ {print}")
	else 
    target_str_select=$(printf "/$string_filter_1|$string_filter_2/ $target_str_gsub")
    fi
    if [ ! -z "$target_str_sort" ]; then
     target_str_sort=rev
	else
     target_str_sort=tee
    fi

target_array=`expect -c 'log_user 0; set timeout -1; spawn telnet '"$msa_addr"' '"$msa_port"'; expect -nocase "Login" {send "'"$msa_login"'\r"}; expect -nocase "Password:" {send "'"$msa_passwd"'\r"}; expect {\#} {send "set cli-parameters base 10 api brief enabled pager disabled\r"}; expect {\#} {log_user 1; send "'"show $msa_target\r"'"}; expect {\#} {send "exit\r"};' | tr -d '\r' | awk '/'$string_filter_1'/,/<\/OBJECT>/ {gsub("<COMP G=\"0\" P=\".*\"/>", "");{sub(/^[ \t]+/, ""); print}}' | awk "$target_str_select" | grep -o $target_str_grep | tr -d '"<>' | sed 'N;s/\n/;/' | "$target_str_sort"`

if [ "$6" = "" ]; then
    first="1"
    counter="0"
    printf "{\n"
    printf "\t\"data\":[\n\n"
        for targ in $target_array
        do
        targ_block=`echo $targ | cut -d ";" -f 1`
        targ_id=`echo $targ | cut -d ";" -f 2`
	counter=$((counter + 1))
	[ ! -z "$targ_id" ] && {
        if [ "$first" -eq "0" ]; then
	    printf ",\n"
        fi
        first="0"
	printf "\t\t{\"$object_xml_block\": \"$targ_block\", \t\"$object_target_id\": \"$targ_id\"}"
	}
	done
printf "\n\t]\n}"
printf "\n"
# printf "Iterations number: $counter\n"

else
xml_start="$string_filter_1$6\""
xml_end="<\/OBJECT>"
expect -c 'log_user 0; set timeout -1; spawn telnet '"$msa_addr"' '"$msa_port"'; expect -nocase "Login" {send "'"$msa_login"'\r"}; expect -nocase "Password:" {send "'"$msa_passwd"'\r"}; expect {\#} {send "set cli-parameters base 10 api brief enabled pager disabled\r"}; expect {\#} {log_user 1; send "'"show $msa_target\r"'"}; expect {\#} {send "exit\r"};' | awk '/'$xml_start'/,/'$xml_end'/ {gsub("<COMP G=\"0\" P=\"'$6'\"/>", "");{sub(/^[ \t]+/, ""); print}}' | tr -d '\r'
# printf "\n"
fi
