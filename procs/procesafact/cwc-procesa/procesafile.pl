#!/usr/bin/perl

$anio= @ARGV[0];
$mes= @ARGV[1];
$numfact= @ARGV[2];
$proveedor =  @ARGV[3];

$indir="/etc/procs/cwc-procesa/";
$infile="cwc.txt";
$data_file="$indir$infile";

$hfile="claro1.txt";
$h_file="$indir$hfile";



print "Abriendo : $data_file";
open(INFILE, $data_file);
while(<INFILE>)
{
  my($line) = $_;


  chomp($line);

#  $pos5=index($line,"MENSUAL (PR)");
# if ($pos3 >0) { $movefin=19} else { $movefin=14;}


  $pos2=index($line,"$");

  if ($pos2> 0 )
  {      $temp2=substr($line,$pos2+1,40);
        chomp($temp2);
        my @data2= split(/ /,$temp2);
        $preciod=$data2[0];
        $precioq=$data2[2];
 }

}
close(INFILE);

## Proceso de archivo de enlaces 

my $outfile= 'loadclaro.sql';
open(my $outf, '>', $outfile);

print "Abriendo : $data_file";
open(INFILE, $data_file);
while(<INFILE>)
{
  my($line) = $_;
  chomp($line);

  $line=uc($line);
  $ajuste=1; $e1=0;

  my @data10= split(/ /,$line);
  $tmpid=$data10[1];

  my @data11= split(/./,$tmpid);
  $id=$data11[0];

  $pos=index($line,"KBPS");
  if ( $pos < 1 ) 
  { 	$pos=index($line,"MBPS"); 
  	if ($pos > 0 ) { $ajuste=1024;	}
	else 
	{   $pos=index($line,"MBS"); 
  	    if ($pos > 0 ) { $ajuste=1024;	}
	    else
   	    { 	$pos=index($line,"E1"); 
	  	if ($pos>0)
  		{ $rate= 2048; 
                  $metric="KBPS"; 
		  $e1=1;
		  $pos=$pos-2;
		}
	    }
	}
   }

 if (($pos > 1 )&&($e1==0))
 { 	$temp1=substr($line,$pos-6,$pos+5);
        my @data1= split(/ /,$temp1);  

        $rate=$data1[1];
        $metric=$data1[2];

	chomp($rate);
	chomp($metric);
	if ($ajuste>1) { $rate=$rate*$ajuste; $metric="KBPS"; }
 }

 # DESC

  $pos2=index($line,"CARGO MEN"); 
  $desc=substr($line,$pos+4,$pos2-$pos-4);
  $desc=~ s/\s+/ /g;
  $desc=~ s/^\s//;
  $desc=~ s/\s$//;

  chomp($desc);
	
  $pos3=index($line,"MENSUAL (PR)"); 


$movefin=14; $prorata=0;
  if ($pos3 >0) { $movefin=19; $prorata=1} 

  if ($pos2> 0 )
  {      $temp2=substr($line,$pos2+$movefin,40);
	chomp($temp2);
        my @data2= split(/ /,$temp2);
        $preciod=$data2[0];
        $precioq=$data2[1];
 }

	
#print "$id|$rate|$metric|$desc|$preciod|$precioq|$prorata|\n";

print  $outf "insert into facturacion.detallefactura values ($anio,$mes, '$proveedor', $numfact, '$id', $rate, '$metric', '$desc', $preciod, $precioq, $prorata);\n";
}
  
close (INFILE);
close $outf;

