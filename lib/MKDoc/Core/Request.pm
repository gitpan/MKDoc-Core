=head1 NAME

MKDoc::Core::Request - MKDoc request object.


=head1 SUMMARY

Just like CGI.pm, with a few additions.

See perldoc CGI for the base CGI OO API.

=cut
package MKDoc::Core::Request::CompileCGI;
use CGI qw(-compile :all);

package MKDoc::Core::Request;
use strict;
use warnings;
use base qw /CGI/;



=head1 API

=head2 $self->instance();

Returns the L<MKDoc::Core::Request> singleton - or creates it if necessary.

=cut
sub instance
{
    my $class = shift;
    $::MKD_Request ||= $class->new();
    return $::MKD_Request;
}



=head2 $self->clone();

Clones the current object and returns the copy.

=cut
sub clone
{
    my $self = shift;
    return $self->new();
}


sub self_uri
{
    my $self = shift;
    my %opt  = map { "-" . $_ => 1 } ( @_, qw /path_info query/ );
    $opt{relative}  ||= 0;

    my $url  = $self->url (\%opt);
    $url =~ s/(.*?\:\/\/(?:.*?\@)?)(.*):80(?!\d)(.*)/$1$2$3/
        if ($url =~ /(.*?\:\/\/(?:.*?\@)?)(.*):80(?!\d)(.*)/);

    return $url;
}



=head2 $self->param_eq ($param_name, $param_value);

Returns TRUE if the parameter named $param_name returns
a value of $param_value.

=cut
sub param_eq
{
    my $self  = shift;
    my $param = $self->param (shift());
    my $value = shift;
    return unless (defined $param);
    return unless (defined $value);
    return $param eq $value;
}



=head2 $self->param_equals ($param_name, $param_value);

Alias for param_eq().

=cut
sub param_equals
{
    my $self = shift;
    return $self->param_eq (@_);
}



=head2 $self->path_info_eq ($value);

Returns TRUE if $ENV{PATH_INFO} equals $value,
FALSE otherwise.

=cut
sub path_info_eq
{
    my $self  = shift;
    my $param = $self->path_info();
    my $value = shift;
    return unless (defined $param);
    return unless (defined $value);
    return $param eq $value;
}



=head2 $self->path_info_equals ($param_name, $param_value);

Alias for path_info_eq().

=cut
sub path_info_equals
{
    my $self = shift;
    return $self->path_info_eq (@_);
}



=head2 $self->path_info_starts_with ($value);

Returns TRUE if $ENV{PATH_INFO} starts with $value, FALSE otherwise.

=cut
sub path_info_starts_with
{
    my $self  = shift;
    my $param = $self->path_info();
    my $value = quotemeta (shift);
    return $param =~ /^$value/;
}



=head2 $self->method();

Returns the current request method being used, i.e. normally HEAD, GET or POST.

=cut
sub method
{
    my $self = shift;
    return $ENV{REQUEST_METHOD} || 'GET';
}


sub delete
{
    my $self = shift;
    while (@_) { $self->SUPER::delete (shift()) };
}


=head2 $self->is_upload ($param_name);

Returns TRUE if $param_name is an upload, FALSE otherwise.

=cut
sub is_upload
{
    my ($self, $param_name) = @_;
    my @param = grep(ref && fileno($_), $self->SUPER::param ($param_name));
    return unless @param;
    return wantarray ? @param : $param[0];
}


# WARNING! For some reason, the incoming UTF-8 strings
# are not internally marked up as UTF-8 when they should...
sub param
{
    my $self = shift;
    return $self->SUPER::param (@_) if ($self->is_upload (@_));

    if (wantarray)
    {
        my @res = $self->SUPER::param (@_);
        foreach my $element (@res)
        {
            if (defined $element)
            {
                my $tmp = Encode::decode ('UTF-8', $element);
                if (defined $tmp)
                {
                    $element = $tmp;
                }
            }
        }

        return @res;
    }
    else
    {
        my $res = $self->SUPER::param (@_);
        if (ref $res and ref $res eq 'ARRAY')
        {
            foreach my $element (@{$res})
            {
                if (defined $_)
                {
                    my $tmp = Encode::decode ('UTF-8', $element);
                    if (defined $tmp)
                    {
                        $element = $tmp;
                        Encode::_utf8_on ($element);
                    }
                }
            }
        }
        else
        {
            my $tmp = Encode::decode ('UTF-8', $res);
            if (defined $tmp)
            {
                $res = $tmp;
                Encode::_utf8_on ($res);
            }
        }

        return $res;
    }
}


# redirect() doesn't seem to work with CGI.pm 2.89
# this should fix for this particular version.
sub redirect
{
    my $self = shift;
    $CGI::VERSION == 2.89 ? return do {
        my $uri  = shift;
        my $res  = '';
        $res .= "Status: 302 Moved\n";
        $res .= "Location: $uri\n\n";
        $res;
    } : return $self->SUPER::redirect (@_);
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
