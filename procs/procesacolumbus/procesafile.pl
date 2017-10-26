#!/usr/bin/perl

$anio= @ARGV[0];
$mes= @ARGV[1];
$numfact= @ARGV[2];

$indir="/etc/procs/procesacolumbus/";
$infile="columbus.txt";
$data_file="$indir$infile";
$proveedor = "INNOTECHSA"; 

RO:
print "Abriendo : $data_file";
open(INFILE, $data_file);
while(<INFILE>)
{
  my($line) = $_;

  chomp($line);
        $preciod=$data2[0];
        $precioq=$data2[1];

}
close(INFILE);

## Proceso de archivo de enlaces 

my $outfile= 'loadcolumbus.sql';
open(my $outf, '>', $outfile);

print "Abriendo : $data_file";
open(INFILE, $data_file);
while(<INFILE>)
{
  my($line) = $_;
  chomp($line);


  $pos=index($line,"MBps");

 if ($pos > 1 )
 { 	$temp1=substr($line,$pos-3,$pos+5);
        my @data1= split(/ /,$temp1);  

        $rate=$data1[1];
        $metric=$data1[2];

	chomp($rate);
	chomp($metric);
 }

 # DESC

  $pos2=index($line,'$'); 
  $pos3=(index($line,".GT")-7); 
  $desc=substr($line,$pos3+3,$pos2-$pos-4);
  $desc=~ s/\s+/ /g;
  $desc=~ s/^\s//;
  $desc=~ s/\s$//;

  chomp($desc);
	
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

#print  $outf "insert into facturacion.detallefactura values ($anio,$mes, '$proveedor', $numfact, '$id', $rate, '$metric', '$desc', $preciod, $precioq, $prorata);\n";
}
  
close (INFILE);
close $outf;

