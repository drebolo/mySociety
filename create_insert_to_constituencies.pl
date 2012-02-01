#!/usr/bin/perl 

use strict;
use warnings;

open FILE_FROM,"<","england_parliament_constituencies.txt";
open FILE_TO,">","insert_into_constituencies.sql";

my $constituency_id = 1;
while (my $constituency_name = <FILE_FROM>) {
    chomp $constituency_name;
    #print "LINE: ",$constituency_name;
    print FILE_TO "INSERT INTO `constituencies` (`constituency_name`) VALUES ('$constituency_name');\n";
    print FILE_TO "\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 1);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 2);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 3);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 4);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 5);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 6);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 7);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 8);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 9);\n";
    print FILE_TO "INSERT INTO `parties_for_constituencies` (`constituency_id`,`party_id`) VALUES ($constituency_id, 10);\n";
    print FILE_TO "\n";
    $constituency_id++;
}
close FILE_FROM;
close FILE_TO;
