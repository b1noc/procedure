#!/bin/awk -f

function add(one,two) {
	split(one,ts1,":")
	split(two,ts2,":")
	sec1 = ts1[1]*60 + ts1[2]
	sec2 = ts2[1]*60 + ts2[2]
	sum = sec1 + sec2
	min = int(sum/60)
	sec = ((sum/60)%1)*60
	ts = sprintf("%01d:%02.0f", min,sec)
	return ts
}

function subs(one,two) {
	split(one,ts1,":")
	split(two,ts2,":")
	sec1 = ts1[1]*60 + ts1[2]
	sec2 = ts2[1]*60 + ts2[2]
	sum = sec1 - sec2
	min = int(sum/60)
	sec = ((sum/60)%1)*60
	ts = sprintf("%01d:%02.0f", min,sec)
	return ts
}

BEGIN {
	FS=";"
	OFS=";"
	RS="\n"
}

NR==1 {
	while(( getline sumf < FILENAME) > 0 ) {
			split(sumf,sumc,";")
			total = add(total,sumc[10])
			if (sumc[3] ~ /T\+0/){
				break
			}
	}
	close(FILENAME)
	ct=total
}

NR==1 {
	print $0 > "output.csv"
}

NR>=2 {
	ct = subs(ct,$10)
	$1=ct
	print $0 > "output.csv"
}

END {
	print "------" NR
	print "Countdown total: " total
}
