package FreeMind::Convert ;

use 5.008008 ;
use strict ;
use warnings ;
use base qw(Class::Accessor);
use Carp ;
use XML::Simple ;

our $VERSION = '0.01' ;

__PACKAGE__->mk_accessors(qw(format));

sub new {
    my $class   = shift;
    my $self    = bless {}, $class;
    $self->_init(@_);
    $self;
}

sub _init {
    my $self    = shift;
    $self->{depth}  = 0 ;
}

sub loadFile {
    my $self    = shift ;
    my $file    = shift ;
    $self->{mm} = XMLin($file, ForceArray => 1) ;
}

sub toText {
    my $self    = shift ;
    $self->format('text') ;
    $self->_checkNode($self->{mm}) ;
    return $self->{result} ;
}

sub _checkNode {
    my $self    = shift ;
    my $ref     = shift ;
    return if( ! defined( $ref->{node} ) ) ;
    foreach my $refc (@{$ref->{node}}){
        $self->{result} .= qq(\t) x $self->{depth} . "$refc->{TEXT}\n" ;
        $self->{depth}  ++ ;
        $self->_checkNode( $refc ) ;
        $self->{depth}  -- ;
    }
}

1 ;

__END__

=head1 NAME

FreeMind::Convert - FreeMind .mm File Convert to wiki Format

=head1 SYNOPSIS

  use FreeMind::Convert ;
  
  my $mm = FreeMind::Convert->new ;
  $mm->loadFile($file) ;
  print $mm->toText() ;     # convert to plan text format.

=head1 DESCRIPTION

FreeMind::Convert is convert module.

=head1 METHODS

=head2 new

  my $mm = FreeMind::Convert->new ;

Creates and returns a validator instance.

=head2 loadFile

  $mm->loadFile($file) ;

Load .mm file.

=head2 toText

  $mm->toText() ;

Convert to plane text format.

=head1 SEE ALSO

freemind 

L<http://sourceforge.net/projects/freemind/>

=head1 AUTHOR

Takeo Suzuki E<lt>motionbros@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Takeo Suzuki, all rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
