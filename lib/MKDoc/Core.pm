=head1 NAME

MKDoc::Core - Pipeline-ish plugin chain of responsibility


=head1 IMPORTANT NOTE

You should really read L<MKDoc::Core::Article::Overview> and then go through
L<MKDoc::Core::Article::Install> if you haven't yet.


=head1 SUMMARY

MKDoc is a web content management system written in Perl which focuses on
standards compliance, accessiblity and usability issues, and multi-lingual
websites.

At MKDoc Ltd we have decided to gradually break up our existing commercial
software into a collection of completely independent, well-documented,
well-tested open-source CPAN modules.

Ultimately we want MKDoc code to be a coherent collection of module
distributions, yet each distribution should be usable and useful in itself.

L<MKDoc::Core> is part of this effort.

You could help us and turn some of MKDoc's code into a CPAN module. You can
take a look at the existing code at http://download.mkdoc.org/.

If you are interested in some functionality which you would like to see as a
standalone CPAN module, send an email to <mkdoc-modules@lists.webarch.co.uk>.


=head1 DESCRIPTION

This is the top-level module of the MKDoc::Core framework.

It takes care of initialization / cleanup, then triggers each plugin module in
a predefined order.

The order in which plugins are executed is defined by the <SITE_DIR>/plugin
directory.

L<MKDoc::Core> will try to invoke the $class->main() on each of the plugins until one
of them returns the string 'TERMINATE'.


=cut
package MKDoc::Core;
use MKDoc::Core::Init;
use strict;
use warnings;


our $VERSION = '0.1';


sub process
{
    my $class = shift;
    MKDoc::Core::Init::init();
    $class->main();
    MKDoc::Core::Init::clean();
}



sub main
{
    my $class  = shift;
    my @plugin = $class->plugin_list();

    local $::MKD_Current_Plugin;
    foreach my $pkg (@plugin)
    {
        main_import ($pkg);
        $::MKD_Current_Plugin = $pkg;

        my $ret = $pkg->main;
        last if (defined $ret and $ret eq 'TERMINATE');
    }
}



sub plugin_list
{
    my $class = shift;
    $::MKD_Plugin_List ||= do {
        opendir DD, $ENV{SITE_DIR} . '/plugin';
        my @files = sort grep /^\d\d\d\d\d_/, readdir (DD);
        closedir DD;

        [ map { s/^\d\d\d\d\d_//; $_ } @files ];
    };

    return @{$::MKD_Plugin_List};
}



sub main_import
{
    my $pkg  = shift;

    my $file = $pkg;
    $file    =~ s/::/\//g;
    $file   .= '.pm';

    $INC{$file} && return;

    require $file;    
    import $pkg;
}



1;


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


__END__
