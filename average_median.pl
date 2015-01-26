# author: Yifan Zhu

use strict;
use warnings;

print"Start to calculate the AVERAGE and the MEDIAN of every gene in every sample.\n";

my $column=1;
my %average_hash;
my %median_hash;
my %hash;

# count the number of samples

my $num;
open(GEP,"gep.txt") or die("Could not open!");
	while(<GEP>){
		$num=@_=split /\t/,$_;
	}
close(GEP);
print"There are ",$num-1," sample(s)!\n";

# put every sample into the %hash

while($column<$num){
	my $key;
	my $value;
	open(GEP,"gep.txt") or die("could not open");
	while(<GEP>){
		my @row=split /\t/,$_;
		$key=$row[0];
		chomp($value=$row[$column]);
			push @{$hash{$key}},$value;
			}
	close(GEP);
	arrange_hash_average();
	arrange_hash_median();
	print"The $column sample is finished!\n";
	$column=$column+1;
	undef %hash # reinitialize hash
}

print"Outputing now...\n";

# output average

my $file1="average_result.txt";
open FILE1,">$file1";
foreach(reverse (sort keys %average_hash)){
	print FILE1 "$_\t@{$average_hash{$_}}\n";
	}
close FILE1;
# adjust the format
open(FILE3,"average_result.txt");
open(FILE5,">average_final_result.txt");
while(<FILE3>)
{
	s/ /\t/g;
	print FILE5;
}
close FILE5;
close FILE3;

# output median

my $file2="median_result.txt";
open FILE2,">$file2";
foreach(reverse (sort keys %median_hash)){
	print FILE2 "$_\t@{$median_hash{$_}}\n";
	}
close FILE2;
# adjust the format
open(FILE4,"median_result.txt");
open(FILE6,">median_final_result.txt");
while(<FILE4>)
{
	s/ /\t/g;
	print FILE6;
}
close FILE6;
close FILE4;

print"Done!!";

# arrange_hash_average

sub arrange_hash_average{
	foreach(keys %hash){
		if($_=~/[a-zA-Z]/ || @{$hash{$_}}==1){
			push @{$average_hash{$_}},@{$hash{$_}};
			}
		else{
			my $ave=average(@{$hash{$_}});
			push @{$average_hash{$_}},$ave;
		}
	}
}

# arrange_hash_median

sub arrange_hash_median{
	foreach(keys %hash){
		if($_=~/[a-zA-Z]/ || @{$hash{$_}}==1){
			push @{$median_hash{$_}},@{$hash{$_}};
			}
		else{
			my $med=median(@{$hash{$_}});
			push @{$median_hash{$_}},$med;
		}
	}
}

# average	

sub average{
	my $sum=0;
	my $n=0;
	foreach(@_){
		$sum=$sum+$_;
		$n=$n+1;
	}
	$sum/$n;
}

# median

sub median{
	my @list=@_=sort {$a<=>$b} @_;  # make the array @_ ascending order; if {$b<=>$a},is decending order
	if((@_%2)==0){
		average($list[@_/2-1],$list[@_/2]);
		}
		else{
		$list[@_/2-0.5];
		}
}		
