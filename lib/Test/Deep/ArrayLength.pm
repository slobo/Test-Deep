use strict;
use warnings;

package Test::Deep::ArrayLength;
use Carp qw( confess );

use Test::Deep::Ref;

use vars qw( @ISA );
@ISA = qw( Test::Deep::Ref );

use Data::Dumper qw(Dumper);

sub init
{
	my $self = shift;

	my $val = shift;

	$self->{val} = $val;
}

sub descend
{
	my $self = shift;
	my $a1 = shift;

	return 0 unless Test::Deep::reftype("ARRAY")->descend($a1);

	my $len = $self->{val};

	if (@$a1 != $len)
	{
		$Test::Deep::Stack->push(
			{
				type => $self,
				vals => [$a1, $len],
			}
		);
		return 0;
	}
	else
	{
		return 1;
	}
}

sub render_stack
{
	my $self = shift;
	my ($var, $data) = @_;

	return "array length of $var";
}

sub renderVal
{
	my $self = shift;

	my $val = shift;

	return "array with $val element(s)"
}

sub renderGot
{
	my $self = shift;

	my $got = shift;

	return $self->renderVal(@$got + 0);
}

sub renderExp
{
	my $self = shift;

	return $self->renderVal($self->{val});
}

sub reset_arrow
{
	return 0;
}

sub compare
{
	my $self = shift;

	my $other = shift;

	return Test::Deep::descend($self->{val}, $other->{val});
}

1;