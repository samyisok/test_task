#!/usr/bin/env perl 
#===============================================================================
#        NOTES: ---
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 12/09/2015 16:51:52
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
my @array = qw(1 2 3 4 5 6 7 8 11 22 33 44 1 2 3 444 555 666 777 888);

@array = sort {$a <=> $b} @array;
my @array2 = @array[0..9];

print "@array2"
