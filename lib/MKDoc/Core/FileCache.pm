=head1 NAME

MKDoc::Core::FileCache - Cache::FileCache wrapper for MKDoc::Core

=head1 SYNOPSIS

  sub cached_foo
  {
      my $key = shift;
      my $foo_cache = MKDoc::Core::FileCache->instance ('foo_cache');
      return $foo_cache->get ($key) || do {
          my $val = compute_expensive_foo ($key);
          $foo_cache->set ($key, $val, "1 day");
          $val;
      };
  }

=cut
package MKDoc::Core::FileCache;
use Cache::FileCache;
use strict;
use warnings;


sub instance
{
    my $class = shift || return;
    my $cache = shift || return;
    -d "$ENV{SITE_DIR}/cache" or mkdir "$ENV{SITE_DIR}/cache" or die "No $ENV{SITE_DIR}/cache";
    return new Cache::FileCache ( {
        cache_root => "$ENV{SITE_DIR}/cache",
        namespace => $cache,
    } );
}


1;
