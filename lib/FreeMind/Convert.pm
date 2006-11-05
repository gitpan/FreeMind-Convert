package FreeMind::Convert ;

#use 5.008005 ;
use strict ;
use warnings ;
use base qw(Class::Accessor);
use Carp ;
use XML::Simple ;
use Jcode ;
use HTML::Entities ;

our $VERSION = '0.02' ;

__PACKAGE__->mk_accessors(qw(_format setOutputJcode));

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
    $self->_format('text') ;
    $self->_checkNode($self->{mm}) ;
    return $self->{result} ;
}

sub toMediaWiki {
    my $self    = shift ;
    $self->_format('mediawiki') ;
    $self->_checkNode($self->{mm}) ;
    return $self->{result} ;
}

sub _filterText {
    my $self    = shift ;
    my $text    = shift ;

    # to unicode
    decode_entities( $text ) ;
    $text =~ s|^<html>(.*)</html>$|$1|i ;
    # to japanese
    if( $self->setOutputJcode() ){
        Jcode::convert( \$text, $self->setOutputJcode, 'utf8' ) ;
    }
    return $text ;
}

sub _checkNode {
    my $self    = shift ;
    my $ref     = shift ;
    return if( ! defined( $ref->{node} ) ) ;
    foreach my $refc (@{$ref->{node}}){
        my $text    = $self->_filterText( $refc->{TEXT} ) ;
        # text
        if( $self->_format() eq 'text' ){
            $self->{result} .= qq(\t) x $self->{depth} . "$text\n" ;
        }
        # MediaWiki
        elsif( $self->_format() eq 'mediawiki' ){
            if( $self->{depth} <= 1 ){
                my $simbol  = '=' x ( $self->{depth} + 2 ) ;
                $self->{result} .= "$simbol $text $simbol\n" ;
            }
            else{
                my $simbol  = '*' x ( $self->{depth} - 1 ) ;
                $self->{result} .= "$simbol $text\n" ;
            }
        }

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
  
  my $mm = FreeMind::Convert->new() ;
  $mm->setOutputJcode('sjis') ; # set Japanese Chara code.
  $mm->loadFile($file) ;
  print $mm->toText() ;         # convert to plan text format.

=head1 DESCRIPTION

FreeMind::Convert is convert module.

=head1 METHODS

=head2 new

  my $mm = FreeMind::Convert->new ;

Creates and returns a validator instance.

=head2 loadFile

  $mm->loadFile($file) ;

Load .mm file.

=head2 setOutputJcode

  $mm->setOutputJcode('sjis') ;

set Output Jcode.

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
