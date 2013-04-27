use strict;
use utf8;
open IN, '<:utf8', 'x-華語對照表.csv';
binmode IN, ':utf8';
<IN>;
my %a2t = qw( 萌 發穎 );
my %t2a = qw( 發穎 萌 );

my $moedict_basedir = "../moedict-webkit";

die "Please checkout $moedict_basedir and have /a/*.json ready" unless -d $moedict_basedir;
my %seen;
while (<IN>) {
    chomp;
    my ($m, undef, $t) = split /,/, $_;
    next unless -e $moedict_basedir . "/a/$m.json";
    next if $seen{$m,$t}++;
    next if $t =~ /\d/;
    $a2t{$m} .= "," if $a2t{$m};
    $a2t{$m} .= ($t eq $m) ? '' : $t;
    $t2a{$t} .= "," if $t2a{$t};
    $t2a{$t} .= ($t eq $m) ? '' : $m;
}
use JSON;
use File::Slurp 'write_file';
mkdir $moedict_basedir . '/a' unless -e $moedict_basedir . '/a';
write_file $moedict_basedir . '/a/xref.json' => encode_json({ t => \%a2t })."\n";
write_file $moedict_basedir . '/t/xref.json' => encode_json({ a => \%t2a })."\n";
