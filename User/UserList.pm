#!/usr/bin/perl
#
# @File UserGet.pm
# @Author rijen
# @Created 11.11.2015 18:27:15
#

package Kernel::GenericInterface::Operation::User::UserList;
use strict;
use warnings;
use MIME::Base64;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use base qw(
    Kernel::GenericInterface::Operation::Common
);

use Kernel::System::ObjectManager;
local $Kernel::OM = Kernel::System::ObjectManager->new();

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DebuggerObject WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}


sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    return $Self->ReturnError(
        ErrorCode    => 'UserGet.AuthFail',
        ErrorMessage => "UserGet: Authorization failing!",
    ) if !$UserID;


    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
	my %List = $UserObject->UserList();
    # return result
    return %List;
}