=head1 NAME

MKDoc::Core::Article::Install - How to install L<MKDoc::Core>



=head1 SUMMARY

This is an article, not a module.



=head1 PRE-REQUISITES

=over

=item Perl 5.8.0 or greater

=item Apache + mod_perl

=item A decent Unix/Linux system.

=back

Note: Windows has been known to work but is not supported.



=head1 INSTALLING THE MODULE

  perl -MCPAN -e 'install MKDoc::Core'

CPAN should pull any required dependencies.



=head1 INSTALLING MKDOC::CORE MASTER DIRECTORY

First you need to choose a master directory for L<MKDoc::Core>, e.g.

  /usr/local/mkdoc


Then you need to run the MKDoc setup as follows:

  perl -MMKDoc::Setup -e install_core /usr/local/mkdoc


You will see a screen as follows:

  1. MKDoc Directory        /usr/local/mkdoc

  D. Delete an option

  I. Install with the options above
  C. Cancel installation


Press 'i' and enter to proceed. Once this is done, provided there were no
errors you should add the following line in your httpd.conf file:

  NameVirtualHost *
  Include /usr/local/mkdoc/conf/httpd.conf



=head1 INSTALLING AN MKDOC::CORE SITE

First you need to choose a domain name for your site, e.g.

  www.example.com

Put www.example.com in your DNS servers or in your hosts file so that
www.example.com points to the right IP address.


Then you need to choose a place to install your site in, for example:

  /var/www/mkdoc/example.com

You've set your domain name, chosen the location of your site, let's
get cracking!

Source your mksetenv.sh:

  source /usr/local/mkdoc/mksetenv.sh

Then issue the following command:

  perl -MMKDoc::Setup -e install_site /var/www/mkdoc/example.com

You should see the following screen:

  1. MKDoc Directory        /usr/local/mkdoc
  2. Site Directory         /var/www/mkdoc/example.com
  3. Server Name            www.example.com
  4. Log Directory          /var/www/mkdoc/example.com/log
  5. Domain Admin Email     tech@example.com

  D. Delete an option

  I. Install with the options above
  C. Cancel installation

  Input your choice:

Make sure that everything's OK and press 'i' to install the site.

If everything goes smoothly you should be almost there!

Restart Apache:

  /usr/local/apache/bin/apachectl restart

Point your web browser to http://www.example.com/. If you see a page
which says 'it worked!' then congratulations, you have installed a
minimal MKDoc site.



=head1 INSTALLING WITH APACHE2

L<MKDoc::Core> + Apache 2 is completely, totally, and utterly
EXPERIMENTAL. If it works, you're in luck. However it will get
there eventually :-)


The only thing which changes in the install procedure is which
file to include in your httpd.conf file. Instead of having:

  Include /usr/local/mkdoc/conf/httpd.conf

  
You include 'httpd2' instead, i.e.

  Include /usr/local/mkdoc/conf/httpd2.conf



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
