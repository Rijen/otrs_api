# --
# Kernel/GenericInterface/Operation/Test/Test.pm - GenericInterface test operation backend
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::User::UserList;
use strict;
use warnings;
use Kernel::System::VariableCheck qw(IsHashRefWithData);
use Kernel::System::ObjectManager;
local $Kernel::OM = Kernel::System::ObjectManager->new();
our $ObjectManagerDisabled = 1;


sub new {
	my ( $Type, %Param ) = @_;
	my $Self = {
	};
	bless( $Self, $Type );
	# check needed objects
	for my $Needed (qw(DebuggerObject)) {
		if ( !$Param {
			$Needed
		}
		) {
			return {
				Success      => 0,
                ErrorMessage => "Got no $Needed!"
			};
		}
		$Self-> {
			$Needed
		}
		= $Param {
			$Needed
		};
	}
	return $Self;
}


sub Run {
	my ( $Self, %Param ) = @_;
	my $UserObject = $Kernel::OM->Get('Kernel::System::User');
	my %List = $UserObject->UserList();
	my @Result;
	foreach my $key(keys %List) {
		my $UserObject = $Kernel::OM->Get('Kernel::System::User');
		my %UserEntry = $UserObject->GetUserData(UserID=>$key);
		push @Result, \%UserEntry;
		
	}
	# return result
	return {
		Success => 1,
        Data    => \@Result,
	};
}
1;

