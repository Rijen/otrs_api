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
=head1 NAME

Kernel::GenericInterface::Operation::Test - GenericInterface Operation Test backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();
=cut

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
=item Run()

perform the selected test Operation. This will return the data that
was handed to the function or return a variable data if 'TestError' and
'ErrorData' params are sent.

    my $Result = $OperationObject->Run(
Data => {
	# data payload before Operation
            ...
}
,
);
$Result = {
	Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
	Data            => {
		# result data payload after Operation
            ...
	}
	,
};
my $Result = $OperationObject->Run(
Data => {
	# data payload before Operation
            TestError   => 1,
	ErrorData   => {
		...
	}
	,
}
,
);
$Result = {
	Success         => 0,                                   # it always return 0
        ErrorMessage    => 'Error message for error code: 1',   # including the 'TestError' param
	Data            => {
		ErrorData   => {
			# same data was sent as
                                                                # 'ErrorData' param
		}
		,
            ...
	}
	,
};
=cut

sub Run {
	my ( $Self, %Param ) = @_;
	my $UserObject = $Kernel::OM->Get('Kernel::System::User');
	my %List = $UserObject->UserList();
	my @Result;
	for my $key(keys %List) {
		my $UserObject = $Kernel::OM->Get('Kernel::System::User');
		my %UserEntry = $UserObject->GetUserData(UserID=>$key);
		my $UserBundle = {
			%UserEntry,
		};
		push @Result, $UserBundle;
	}
	# return result
	return {
		Success => 1,
        Data    => \@Result,
	};
}
1;
=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
