use utf8;
local @ARGV = 'x-華語對照表.csv';
<>;
my %a2t = qw( 萌 發穎 );
my %t2a = qw( 發穎 萌 );
die "Please checkout ../moedict-webkit/ and have /a/*.json ready" unless -d "../moedict-webkit/";
my %seen;
while (<>) {
    chomp;
    my ($m, undef, $t) = split /,/, $_;
    next unless -e "../moedict-webkit/a/$m.json";
    next if $seen{$m,$t}++;
    next if $t =~ /\d/;
    $a2t{$m} .= "," if $a2t{$m};
    $a2t{$m} .= ($t eq $m) ? '' : $t;
    $t2a{$t} .= "," if $t2a{$t};
    $t2a{$t} .= ($t eq $m) ? '' : $m;
}
use JSON;
use File::Slurp 'write_file';
write_file '../moedict-webkit/a/xref.json' => encode_json({ t => \%a2t })."\n";
write_file '../moedict-webkit/t/xref.json' => encode_json({ a => \%t2a })."\n";
