#! /bin/ksh
#-----------

#echo "Enter Date MMDDYY"
#read xdat

xdat=`date +"%m%d%y"`
xdat1=`date +"%m/%d/%y"`
who am i
xuse=`whoami`
curdir=`pwd`
mkdir Send
mv *.zip $curdir/Send
rm -f *.txt
cp /tables/home/CinglePoint/ReportsToMail/*$xdat*.txt .
ls *.txt | wc -l
for xn1 in `ls -t *ALH*ErrorSqls*`
	do
	xnumb=`echo $xn1 | awk -F'[_]' '{print $3}'`
done

zip $xdat"_"$xnumb"_CINP_SqlFiles.zip" *CINP_Files.txt
zip $xdat"_"$xnumb"_CINP_ErrorSqls.zip" *ErrorSqls.txt

for x in `ls -t *ErrorSqls_ALL*`
	do
	awk 'sub("$","\r")' $x > _$x
done
for x1 in `ls -t *AllMkts_DatFiles.txt*`
	do
	awk 'sub("$","\r")' $x1 > _$x1
done

> out.mail
echo "These are the log files for Dealer tables on $xdat1." >> out.mail
uuencode $xdat"_"$xnumb"_CINP_SqlFiles.zip" $xdat"_"$xnumb"_CINP_SqlFiles.zip" >> out.mail
uuencode $xdat"_"$xnumb"_CINP_ErrorSqls.zip" $xdat"_"$xnumb"_CINP_ErrorSqls.zip" >> out.mail
uuencode _$x $x >> out.mail
uuencode _$x1 $x1 >> out.mail
mailx -s "CinglePoint - Dealers Tables - $xdat1" $xuse@att.com  < out.mail
rm -f out.mail
