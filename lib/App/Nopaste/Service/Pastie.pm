package App::Nopaste::Service::Pastie;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub uri { 'http://pastie.org/pastes/new' }

my $languages = {
    objc => 1,
    actionscript => 2,
    ruby => 3,
    rails => 4,
    diff => 5,
    text => 6,
    c => 7,
    cpp => 7,
    css => 8,
    java => 9,
    javascript => 10,
    html4strict => 11,
    html => 11,
    # <option value="12">HTML (ERB / Rails)</option>
    bash => 13,
    sql => 14,
    php => 15,
    python => 16,
    perl => 18,
    yaml => 19,
    csharp => 20,
    go => 21
};

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;
    
    $mech->submit_form(
        form_number => 1,
        fields => {
            "paste[body]"          => $args{text},
            "paste[authorization]" => 'burger', # set with JS to avoid bots
            "paste[parser_id]"     => $languages->{$args{lang}},
            "paste[restricted]"     => $args{private}
        }
    );
}

sub return {
    my $self = shift;
    my $mech = shift;

    # For now, let's naively believe that pastie.org will always return
    # the following patterns for private and public pastes
    return (1, $mech->base) if $mech->success 
        and ($mech->title =~ /Private Paste/ or $mech->title =~ /\#(?:\d+})/);

    return (0, "Could not construct paste link.");
}

1;

=head1 NAME

App::Nopaste::Service::Pastie - http://pastie.org

=cut

