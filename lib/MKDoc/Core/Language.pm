=head1 NAME

MKDoc::Core::Language - Language class for the L<MKDoc::Core> framework


=head1 SUMMARY

The list of languages supported by L<MKDoc::Core> is defined in two config files.

These two config files are loaded from (by order of preference):

=over

=item $ENV{SITE_DIR}/Language/

=item $ENV{MKDOC_DIR}/Language/

=item @INC/MKDoc/Core/Language/languages/

=back


The two file are the following:

=over

=item languages.conf - All the languages to support, including those from right to left

=item languages_rtl.conf - Just the languages which are written from right to left

=back

=cut
package MKDoc::Core::Language;
use strict;
use warnings;


our %LANGUAGES = do {

    my ($conf) =
        grep { -e $_ && -f $_ }
	map { defined $_ ? "$_/MKDoc/Core/Language/languages.conf" : () }
	        ($ENV{SITE_DIR}, $ENV{MKDOC_DIR}, @main::INC);

    open FP, "<:utf8", $conf;
    my @res =
        map {
	    chomp ($_);
	    s/#.*//;
	    s/^\s+//;
	    s/\s+$//;
	    /\S\s+\S/ ? split /\s+/, $_, 2 : ()
	} <FP>;

    close FP;
    @res;
};


our %LANGUAGES_RTL = do {

    my ($conf) =
        grep { -e $_ && -f $_ }
	    map { defined $_ ? "$_/MKDoc/Core/Language/languages_rtl.conf" : () }
	        ($ENV{SITE_DIR}, $ENV{MKDOC_DIR}, @main::INC);

    open FP, "<:utf8", $conf;
    my @res =
        map {
	    chomp ($_);
	    s/#.*//;
	    s/^\s+//;
	    s/\s+$//;
	    /\S\s+\S/ ? split /\s+/, $_, 2 : ()
	} <FP>;

    close FP;
    @res;
};



=head1 Methods / API

=head2 $class->new ($iso_code);

Instantiates a new L<MKDoc::Core::Language> object for $iso_code.

Returns undef if $iso_code is not defined in the languages.conf file.

=cut
sub new
{
    my $class = shift;
    my $lang  = shift;
    $LANGUAGES{$lang} || return;
    return bless \$lang, $class;
}



=head2 $self->code();

Returns the iso code of a given language object, e.g:

  my $lang = new MKDoc::Core::Language ('en');
  print $lang->code(); # should print 'en'

=cut
sub code
{
    my $self = shift;
    return $$self;
}



=head2 $self->label();

Returns the label associated with a given language object, e.g:

  my $lang = new MKDoc::Core::Language ('en');
  print $lang->label(); # should print 'English'

=cut
sub label
{
    my $self = shift;
    my $code = $self->code;
    return $LANGUAGES{$code};
}



=head2 $thing->code_list()

Returns a list of ISO codes of all languages, sorted by the Unicode
value of their associated label.

=cut
sub code_list
{
    return sort { $LANGUAGES{$a} cmp $LANGUAGES{$b} } keys %LANGUAGES;
}



=head2 $self->align();

In order to do proper multilingual HTML formatting, you need to have a
sensible value for the XHTML align="left|right" attribute.

If the language is written left to right, this method returns 'left'.

If the language is written right to left, this method returns 'right'.

=cut
sub align
{
    my $self = shift;
    my $code = $self->code;
    return $LANGUAGES_RTL{$code} ? 'right' : 'left';
}



=head2 $self->align_opposite();

In order to do proper multilingual HTML formatting, you need to have a
sensible value for the XHTML align="left|right" attribute.

This method does the exact opposite as $self->align(), i.e.

If the language is written left to right, this method returns 'right'.

If the language is written right to left, this method returns 'left'.

=cut
sub align_opposite
{
    my $self = shift;
    my $code = $self->code;
    return $LANGUAGES_RTL{$code} ? 'left' : 'right';
}



=head2 $self->dir()

In order to do proper multilingual HTML formatting, you need to have a
sensible value for the XHTML dir="ltr|rtl" attribute.

If the language is written left to right, this method returns 'ltr'.

If the language is written right to left, this method returns 'rtl'.

=cut
sub dir
{
    my $self = shift;
    my $code = $self->code;
    return $LANGUAGES_RTL{$code} ? 'rtl' : 'ltr';
}


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
