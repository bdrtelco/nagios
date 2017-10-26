#!/usr/bin/perl

$indir="/etc/procs/routes/";
$outdir="/etc/procs/routes/history/";
$rsfile="rutas-start.txt";
$rmfile="rutas-mem.txt";

$outfile="rutas-comp.csv";

$startfile="$indir$rsfile";
$memfile="$indir$rmfile";

$memf=0;
$memtot=0;

$startf=0;
$starttot=0;


sub addstart
{
  chomp($red);
  chomp($gw);
  $skip=0;

  $network=$red.",".$mask.",".$gw;

  if ($red eq "default") {$network="0.0.0.0,0.0.0.0,$gw"; }

    if (exists($startr{$network}))
    {   $startr{$netwrok}=0;
    } else
    {   $startr{$network}=0;
}
}

sub leestart
{
   open(INFILE, $startfile);
   while(<INFILE>)
   {
        my($line) = $_;
        chomp($line);

        my @data= split(/\s+/,$line);

        $red=$data[0];
        $gw=$data[1];
        $mask=$data[2];
        &addstart($red,$gw,$mask);
   }
   close (INFILE);
}

sub addmem
{
  chomp($red);
  chomp($gw);

  $network=$red.",".$mask.",".$gw;

  if ($red eq "Destination") {return;  }
  if ($red eq "Kernel") {return; }
  if ($gw eq "0.0.0.0") {return; }

  if (exists($memr{$network}))
  {     $memr{$netwrok}=0;
  } else
  {     $memr{$network}=0;
  }
}

sub leemem
{
   open(INFILE, $memfile);

   while(<INFILE>)
   {
        my($line) = $_;
        chomp($line);
        my @data= split(/\s+/,$line);

        $red=$data[0];
        $gw=$data[1];
        $mask=$data[2];
        &addmem($red,$gw,$mask);
   }
   close (INFILE);
}


sub outmem
{
        open(OUT, ">>$outdir$outfile");
        print OUT "Start/Mem,Subnet,mask,gw,found\n";
        foreach $subn (sort keys %memr)
        {
            print OUT "mem,$subn,$memr{$subn}\n";
            $memtot=$memtot+1;
            if ( $memr{$subn} == 1 ) {$memf=$memf+1;}

        }
        foreach $subn(sort keys %startr)
        {
            print OUT "start,$subn,$startr{$subn}\n";
            $starttot=$starttot+1;
            if ( $startr{$subn} == 1 ) {$startf=$startf+1;}
        }
        close (OUT);
}

sub checkroute
{
        foreach $subn(sort keys %startr)
        {
                if (exists($memr{$subn}))
                {     $memr{$subn}=1;
                }
        }
        foreach $subx(sort keys %memr)
        {       if (exists($startr{$subx}))
                {     $startr{$subx}=1;
                }
        }
}

sub getdate
{
($sec,$min,$hr,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$mon++;
$year += 1900;
$date = "$year-$mon-$mday";
}



getdate;
leestart;
leemem;
checkroute;
outstart;
outmem;


$subject="Rutas gw-nagios. Found: $memf. Ram: $memtot, Boot: $starttot. Generado: $date";

$email="tic-tele-tec\@banrural.com.gt";

# send an email using /bin/mail

$body="body.txt";
$tarzipfile="gw-nagios-$fecha.tar.gz";
$body="$outdir$body";
open(OUTB, ">>$body");
print (OUTB "Estadisticas de tablas de ruteo  a la fecha : $date. \n\n");
print (OUTB "   Rutas en Memoria           :    Found $memf,      Total: $memtot\n\n");
print (OUTB "   Rutas /etc/sysconfig/routes:    Found $startf     Total: $starttot )\n\n");
print (OUTB "Esta es una generacion automatica.\n" );
close (OUTB);

system("/bin/mail -s \"$subject\" -a $outdir$outfile $email < $body");
#system("tar cvfz $outdir$tarzipfile $outdir$netlist $outdir$iplist  $outdir$iplist.sql");
system("rm $body $outdir$outfile" );





