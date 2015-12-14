#===============================================================================
#
#         FILE: Filereader.pm
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
#      VERSION: 1.0
#      CREATED: 12/07/2015 03:08:52
#===============================================================================
package Filereader;
use strict;
use warnings;
use Moose;
use Carp;
use File::stat;

has 'filename' => (
    is     => 'ro',
    isa    => 'Str',
    reader => 'get_filename',
);

has 'mtime' => (
    is     => 'rw',
    isa    => 'Num',
    reader => 'get_mtime',
    writer => 'set_mtime',
);

has 'size' => (
    is     => 'rw',
    isa    => 'Num',
    reader => 'get_size',
    writer => 'set_size',
);

has 'content' => (
    is     => 'rw',
    reader => 'get_content',
    writer => 'set_content',
);

has 'success' => (
    is     => 'rw',
    isa    => 'Bool',
    reader => 'get_success',
    writer => 'set_success',
);

sub get_mtime_from_fh {
    my $self = shift;
    open my $fh, "<", $self->get_filename;
    my $mtime = stat($fh)->mtime;
    close $fh;
    return $mtime;
}

sub get_size_from_fh {
    my $self = shift;
    open my $fh, "<", $self->get_filename;
    my $size = stat($fh)->size;
    close $fh;
    return $size;
}

sub _update_mtime_size {
    my $self = shift;
    $self->set_mtime( $self->get_mtime_from_fh() );
    $self->set_size( $self->get_size_from_fh() );
}

sub _make_content {
    my $self = shift;
    my $fh   = shift;
    if ($fh) {
        my $file_content;
        while ( readline($fh) ) {
            $file_content .= $_;
        }
        $self->set_content($file_content);
        $self->_update_mtime_size;
    }
}

sub read {
    my $self = shift;
    if (    $self->get_success
        and $self->get_mtime
        and $self->get_size
        and $self->get_mtime_from_fh == $self->get_mtime
        and $self->get_size_from_fh == $self->get_size )
    {
        return $self->get_content;
    }
    else {
        $self->try_open_file;
        return $self->get_content;

    }

}

sub try_open_file {
    my $self      = shift;
    my $filename  = $self->get_filename;
    my $tmp_check = open my $fh, '<', $filename;
    if ($tmp_check) {
        $self->set_success(1);
        $self->_make_content($fh);
        return 1;
    }
    else {
        $self->set_success(0);
    }
    close $fh;
}

sub BUILD {
    my $self = shift;
    $self->try_open_file;
}

1;
