=head1 NAME

MKDoc::Setup::MKDoc - Installs MKDoc framework somewhere on the system.


=head1 SYNOPSIS

  perl -MMKDoc::Setup -e install_core


=head1 SUMMARY

L<MKDoc::Core> is an application framework which aims at supporting easy installation
and management of multiple MKDoc products (such as MKDoc::Authenticate, MKDoc::Authorize,
MKDoc::CMS, MKDoc::Forum, etc) onto multiple virtual hosts / websites.

Before you can install MKDoc sites, you need to install L<MKDoc::Core> in a master directory
where the software can maintain various default configuration files and other things.
You only need to do this once.


=head1 AUTHOR

Copyright 2003 - MKDoc Holdings Ltd.

Author: Jean-Michel Hiver <jhiver@mkdoc.com>

This module is free software and is distributed under the same license as Perl
itself. Use it at your own risk.


=head1 SEE ALSO

  Petal: http://search.cpan.org/author/JHIVER/Petal/
  MKDoc: http://www.mkdoc.com/

Help us open-source MKDoc. Join the mkdoc-modules mailing list:

  mkdoc-modules@lists.webarch.co.uk

=cut
package MKDoc::Setup::MKDoc;
use strict;
use warnings;
use File::Spec;
use base qw /MKDoc::Setup/;


sub main::install_core
{
	$::MKDOC_DIR = shift (@ARGV);
	__PACKAGE__->new()->process();
}


sub keys { qw /MKDOC_DIR/ }


sub label
{
    my $self = shift;
    $_ = shift;
    /MKDOC_DIR/ and return "MKDoc Directory";
    return;
}


sub initialize
{
    my $self = shift;
    $self->{MKDOC_DIR} = $::MKDOC_DIR || $ENV{MKDOC_DIR} || '/usr/local/mkdoc';
}


sub validate
{
    my $self = shift;
    my $cur_dir = $self->{MKDOC_DIR};

    $cur_dir    = File::Spec->rel2abs ($cur_dir);
    $cur_dir    =~ s/\/$//;

    -d $cur_dir or mkdir $cur_dir or do {
        print "Impossible to create $cur_dir";
        return 0;
    };

    -d "$cur_dir/conf" or mkdir "$cur_dir/conf" or do {
        print "Impossible to create $cur_dir/conf";
        return 0;
    };

    $self->{MKDOC_DIR} = $cur_dir;
    return 1;
}


sub install
{
    my $self = shift;
    my $cur_dir = $self->{MKDOC_DIR};

    $cur_dir    = File::Spec->rel2abs ($cur_dir);
    $cur_dir    =~ s/\/$//;

    -d $cur_dir        or do { mkdir $cur_dir        || die "Cannot create $cur_dir. Reason: $!" };
    -d "$cur_dir/conf" or do { mkdir "$cur_dir/conf" || die "Cannot create $cur_dir. Reason: $!" };
    -d "$cur_dir/cgi"  or do { mkdir "$cur_dir/cgi"  || die "Cannot create $cur_dir. Reason: $!" };

    chmod 0755, $cur_dir, "$cur_dir/conf", "$cur_dir/cgi";


    print "\n\n";
    $self->install_mksetenv();
    $self->install_httpd_conf();
    $self->install_mkdoc_cgi();
    $self->install_success();
    exit (0);
}


sub install_mksetenv
{
    my $self = shift;
    my $cur_dir = $self->{MKDOC_DIR};

    open FP, ">$cur_dir/mksetenv.sh" || die "Cannot create '$cur_dir/mksetenv.sh'";
    print FP join "\n", (
	qq |export MKDOC_DIR="$cur_dir"|,
       );
    print FP "\n";
    close FP;

    chmod 0644, "$cur_dir/mksetenv.sh";
}


sub install_httpd_conf
{
    my $self = shift;
    my $cur_dir = $self->{MKDOC_DIR};

    open FP, ">>$cur_dir/conf/httpd.conf" || die "Cannot touch $cur_dir/conf/httpd.conf. Reason: $!";
    print FP '';
    close FP;

    chmod 0644, "$cur_dir/conf/httpd.conf";
}


sub install_mkdoc_cgi
{
    my $self = shift;
    my $cur_dir = $self->{MKDOC_DIR};

    open FP, ">$cur_dir/cgi/mkdoc.cgi";
    print FP join '', <DATA>;
    close FP;

    chmod 0755, "$cur_dir/cgi/mkdoc.cgi";
}


sub install_success
{
    my $self = shift;
    my $cur_dir = $self->{MKDOC_DIR};

    print "Successfully created $cur_dir/mksetenv.sh\n\n";
    print "At this point you probably should add the following in your Apache httpd.conf file:\n\n";

    print "# Include all MKDoc sites\n";
    print "Include $cur_dir/conf/httpd.conf\n\n";
}



1;


__DATA__
#!/usr/bin/perl
use MKDoc::Core;
use Data::Dumper;
use strict;
use warnings;

eval { MKDoc::Core->process() };
if (defined $@ and $@)
{
    print "Status: 500 Internal Server Error\n";
    print "Content-Type: text/html; charset=UTF-8\n\n";
    if (ref $@) { $@ = Dumper ($@) }
    $@ = Dumper (\%ENV) . "\n\n" . $@;
    warn "SOFTWARE_ERROR\n\n" . $@ . "\n\n";
}

BEGIN {
    $SIG{'__WARN__'} = sub {
        # trap some common error strings that otherwise flood the error log files
        warn $_[0] unless ($_[0] =~ /byte of utf8 encoded char at/ or
                           $_[0] =~ /is deprecated/                or
                           $_[0] =~ /IMAPClient\.pm line/);
    }
}
