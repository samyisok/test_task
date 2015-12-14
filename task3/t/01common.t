#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: 01common.pl
#
#        USAGE: ./01common.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 12/08/2015 02:48:37
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use_ok q{My::Filereader};
use File::Slurp;

my $message1 = "test string 1";
my $message2 = "test 2\n test21";
my $trunkname = "exist.txt";

sub update_trunk_file {
    my $message = shift;
    my $filename = shift;
    open my $fh, '>', $filename or die "can't create file $!";
    print $fh $message;
    close $fh;
}

subtest 'basic func' => sub {
    my $file1 = Filereader->new(
        filename => 'not_exist.txt'
    );
    ok($file1->get_success == 0, "ok, file not open");
    
    update_trunk_file($message1, $trunkname);

    my $file2 = Filereader->new(
        filename => 'exist.txt'
    );
    ok($file2->get_success, "ok, file open");
    
    my $buf = $file2->read;
    ok($message1 eq $buf, "ok, content1 ok");
    
    update_trunk_file($message2, $trunkname);
    my $buf2 = $file2->read;
    ok($message2 eq $buf2, "ok, content2 ok");
    
    ok(!defined($file1->read), "ok, must be undef");
    ok($file2->get_size_from_fh == 14, "ok, can get size from file");
};

unlink $trunkname if (-e $trunkname);

done_testing();

