#!/bin/bash

if [ "$X_NUMBER_OF_TRIALS" == "" -o "$X_NUMBER_OF_TRIALS" == "null" ]; then
    X_NUMBER_OF_TRIALS=21
fi

sum_perc=0
sum_ms=0
last_sum_perc=0
last_sum_ms=0
array_perc=()
array_last_perc=()
array_ms=()
array_last_ms=()
cnt_curr=0
cnt_last=0
for ((i=0;i<$X_NUMBER_OF_TRIALS;i++))
do
    perc=`jq -r ".metrics[$i].completion_percentage" ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json`
    ms=`jq -r ".metrics[$i].elapsed_time_in_milliseconds" ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json`
    
    if [ "$perc" == "" -o "$perc" == "null" ]; then
        perc=0
    else
        array_perc+=( $perc )
    fi
    
    if [ "$ms" == "" -o "$ms" == "null" ]; then
        ms=0
    else
        if [ "$perc" == "100" ]; then
            array_ms+=( $ms )
            ((sum_ms=sum_ms+$ms))
        else
            ms=0
        fi
    fi
    
    ((sum_perc=sum_perc+$perc))
    
    last_perc=`jq -r ".metrics[$i].completion_percentage" ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json`
    last_ms=`jq -r ".metrics[$i].elapsed_time_in_milliseconds" ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json`
    
    if [ "$last_perc" == "" -o "$last_perc" == "null" ]; then
        last_perc=0
    else
        array_last_perc+=( $last_perc )
    fi
    if [ "$last_ms" == "" -o "$last_ms" == "null" ]; then
        last_ms=0
    else
        if [ "$last_perc" == "100" ]; then
            array_last_ms+=( $last_ms )
            ((last_sum_ms=last_sum_ms+$last_ms))
        else
            last_ms=0
        fi
    fi
    
    ((last_sum_perc=last_sum_perc+$last_perc))
done

cnt_curr=$((${#array_perc[@]}>1 ? ${#array_perc[@]} : 1))
cnt_last=$((${#array_last_perc[@]}>1 ? ${#array_last_perc[@]} : 1))

cnt_ms_curr=$((${#array_ms[@]}>1 ? ${#array_ms[@]} : 1))
cnt_ms_last=$((${#array_last_ms[@]}>1 ? ${#array_last_ms[@]} : 1))

IFS=$'\n'
median_perc=`echo "${array_perc[*]}" | sort -n | awk 'NF{a[NR]=$1;c++}END {print (c%2==0)?(a[int(c/2)+1]+a[int(c/2)])/2:a[int(c/2)+1]}'`
median_ms=`echo "${array_ms[*]}" | sort -n | awk 'NF{a[NR]=$1;c++}END {print (c%2==0)?(a[int(c/2)+1]+a[int(c/2)])/2:a[int(c/2)+1]}'`
last_median_perc=`echo "${array_last_perc[*]}" | sort -n | awk 'NF{a[NR]=$1;c++}END {print (c%2==0)?(a[int(c/2)+1]+a[int(c/2)])/2:a[int(c/2)+1]}'`
last_median_ms=`echo "${array_last_ms[*]}" | sort -n | awk 'NF{a[NR]=$1;c++}END {print (c%2==0)?(a[int(c/2)+1]+a[int(c/2)])/2:a[int(c/2)+1]}'`
unset IFS

avg_perc=`echo "scale=0 ; $sum_perc * 100 / $cnt_curr" | bc`
avg_ms=`echo "scale=0 ; $sum_ms / $cnt_ms_curr" | bc`

last_avg_perc=`echo "scale=0 ; $last_sum_perc * 100 / $cnt_last" | bc`
last_avg_ms=`echo "scale=0 ; $last_sum_ms / $cnt_ms_last" | bc`

echo "######################### EVALUATING MODEL ##################################"
echo "######################### EVALUATING MODEL ##################################"
echo "######################### EVALUATING MODEL ##################################"

echo Last Percentage Array: ${array_last_perc[*]}
echo Last Median Percentage: `echo "scale=2 ; $last_median_perc" | bc`%
echo Last Average Percentage: `echo "scale=2 ; $last_avg_perc / 100" | bc`%
echo "Last Average time (Full Rounds): `echo "scale=2 ; $last_avg_ms / 1000" | bc`s"
#echo Last Median time: `echo "scale=2 ; $last_median_ms / 1000" | bc`s

echo Percentage Array: ${array_perc[*]}
echo Median Percentage: `echo "scale=2 ; $median_perc" | bc`%
echo Average Percentage: `echo "scale=2 ; $avg_perc / 100" | bc`%
echo "Average time (Full Rounds): `echo "scale=2 ; $avg_ms / 1000" | bc`s"
#echo Median time: `echo "scale=2 ; $median_ms / 1000" | bc`s