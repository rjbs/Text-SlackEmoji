use strict;
use warnings;
package Text::SlackEmoji;
# ABSTRACT: data for mapping Slack :emoji_strings: into Unicode text

use File::ShareDir ();

=head1 SYNOPSIS

  use Text::SlackEmoji;

  my $emoji = Text::SlackEmoji->emoji_map;

  $slack_message =~ s!:([-+a-z0-9_]+):!$emoji->{$1} // ":$1:"!ge;

=head1 DESCRIPTION

This library is basically just a container around a hash mapping strings like
"disappointed_relieved" to Unicode text like 😥 .

=head1 SECRET ORIGINS

I made the first version of this lookup to power a little C<irssi> plugin so
that when using the Slack IRC gateway, I'd see the same emoji as the people
using the Slack app, at least when possible.

=cut

our %Emoji;
sub initialize_emoji {
  $_[0]->load_emoji unless %Emoji;
}

sub load_emoji {
  my $emoji_file = File::ShareDir::dist_file('Text-SlackEmoji', 'emoji.pl');
  %Emoji = %{ do $emoji_file };
  return;
}

__PACKAGE__->initialize_emoji;

=method emoji_map

This method takes no arguments and returns a hashref mapping Slack emoji names
to Unicode strings.  The strings may be more than one character long.

=cut

sub emoji_map {
  my ($self) = @_;
  return { %Emoji };
}

1;
