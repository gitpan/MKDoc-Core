package MKDoc::Core::ResourceFinder;
use warnings;
use strict;

our $DIRS = undef;


sub permanent_resource_dirs
{
    $DIRS and return @{$DIRS};
    
    my @res = ();
    push @res, $ENV{MKDOC_DIR} . '/resources';
    push @res, map { "$_/MKDoc/resources" } grep ( !/^\Q$ENV{MKDOC_DIR}\E$/, @INC );

    my @new_res = ();
    my %seen    = ();
    foreach my $res (@res)
    {
        $seen{$res} and next;
        $seen{$res} = 1;
        -d $res or next;
        push @new_res, $res;
    }

    $DIRS = \@new_res;
    
    return @{$DIRS};
}


sub rel2abs
{
    my $rel = shift;
    $rel =~ s/^\///;

    foreach my $dir ("$ENV{SITE_DIR}/resources", permanent_resource_dirs())
    {
        $dir || next;
        my $file = "$dir/$rel";
        -f "$file.deleted" and return;
        -f $file and return $file;
    }

    return;
}


1;


__END__
