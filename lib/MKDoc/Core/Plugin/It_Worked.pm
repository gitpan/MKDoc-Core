=head1 NAME

MKDoc::Core::Plugin::It_Worked - Very simple plugin.

=head1 SUMMARY

This is the equivalent of a 'Hello World' program, except it displays an
Apache-style 'It Worked!'.

=cut
package MKDoc::Core::Plugin::It_Worked;
use base qw /MKDoc::Core::Plugin/;
use strict;
use warnings;


sub location { '/' }


1;


__END__


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
