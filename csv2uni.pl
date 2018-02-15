#!/usr/bin/env perl
use utf8;
use strict;
my @map = read_file( 'x-造字.csv', binmode => ':utf8' ) ;
shift @map;
my (%symToUni, %symToPua);
for (@map) {
    chomp;
    my ($code, $uni) = split /,/, $_;
    $symToUni{chr hex $code} = $uni; # include IDS
    $symToPua{chr hex $code} = $uni unless length $uni > 1; # exclude IDS
}
for my $file (@ARGV) {
    my $csv = read_file( $file, binmode => ':utf8' ) ;
    $csv =~ s!<img src="/holodict_new/fontPics/(....)\.gif" border="0" >!$1!g;
    $csv =~ s/(${\join('|', keys %symToPua)})/$symToPua{$1}/ego;
    $csv =~ s/(${\join('|', keys %symToUni)})/$symToUni{$1}/ego;
    write_file( "$file.uni", {binmode => ':utf8'}, $csv ) ;
}
for my $file (<raw/*.csv>) {
    my $csv = read_file( $file, binmode => ':utf8' ) ;
    $file =~ s/raw/pua/;
    $csv =~ s/([${\join('', keys %symToPua)}])/$symToPua{$1}/ego;
    write_file( $file, {binmode => ':utf8'}, $csv ) ;
    print "$file\n";

    $file =~ s/pua/uni/;
    $csv =~ s/([${\join('', keys %symToUni)}])/$symToUni{$1}/ego;
    write_file( $file, {binmode => ':utf8'}, $csv ) ;
    print "$file\n";
}
sub read_file {
    my $file_name = shift;
    local *FH;
    open FH, '<:utf8', $file_name or die $!;
    return <FH> if wantarray;
    read FH, my $buf, -s FH;
    return $buf;
}
sub write_file {
    my $file_name = shift; shift if @_ and ref $_[0];
    local *FH;
    open FH, '>:utf8', $file_name or die $!;
    print FH @_ or die $!;
}

