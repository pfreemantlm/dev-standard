package Telemetry::b64pack;

# GetPackedString(array of bits) => compressed output string
sub GetPackedString
{
	my @aBitString = ();
	foreach $iInNum (@_)
	{
		my $iNum = $iInNum-1;
		my $iBytePos = int ($iNum/8);
		my $size = @aBitString;
		my $iLenNeeded = ($iBytePos +1) * 8;
		if($iLenNeeded > $size)
		{
			$iExtendBy = $iLenNeeded - $size;
			for(1..$iExtendBy)
			{
				push @aBitString, "0";
			}

		}
		my $iBitPos = $iBytePos * 8 + (8- $iNum%8);
		$aBitString[$iBitPos-1] = "1";
	}

	my $iTailBits = @aBitString % 8;
	if(0 != $iTailBits)
	{
		my $iAddBits = 8 - $iTailBits;
		for(1..$iAddBits)
		{
			push @aBitString, "0";
		}
	}

	my $sBitString = join('', @aBitString);
	return _PackBitString($sBitString);
}


use MIME::Base64;

sub _GetOffsetSection
{
	my $iInNum = $_[0];
	my $sNumtoB64 = "ABCDEFGHIJKLMNOPQRSTUVZWYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	my @aNumtoB64 = split(//, $sNumtoB64);
	$iPart1 = $iInNum % 64;
	$iInNum = $iInNum /64;
	$iPart2 = $iInNum % 64;
	$iInNum = $iInNum /64;
	$iPart3 = $iInNum % 64;
	return "*" . join("", @aNumtoB64[$iPart1, $iPart2, $iPart3]);
}

sub _PackBitString
{
	my $sPackedString = "";
	my $sBitString = $_[0];
	my $bSkipping = 0;
	my $iStartIdx = 0;
	for(my $iPos = 0; $iPos < length($sBitString); $iPos+=24)
	{
		my $sSubstr = substr $sBitString, $iPos, 24;
		if($bSkipping)
		{
			if(-1 < index($sSubstr, '1'))
			{
				my $iSkipCount = $iPos - $iSkipIdx;
				# Only do the skipping if it is worth it.
				if($iSkipCount >= 24)
				{
					my $iLen = $iSkipIdx - $iStartIdx;
					if(0 < $iLen)
					{
						my $sSubBitString = substr $sBitString, $iStartIdx, $iLen;
						$sPackedString .= encode_base64(pack("B*", $sSubBitString), "");
					}
					$sPackedString .= _GetOffsetSection($iSkipCount);					
					$iStartIdx = $iPos;
				}

				$bSkipping = 0;
			}

		}
		else
		{

			if(0 > index($sSubstr, '1'))
			{
				$bSkipping = 1;
				$iSkipIdx = $iPos;
			}

		}
	}

	my $iLen = (length $sBitString) -  $iStartIdx;
	if(0 < $iLen)
	{
		my $sSubBitString = substr $sBitString, $iStartIdx, $iLen;
		$sPackedString .= encode_base64(pack("B*", $sSubBitString), "");
	}

	return $sPackedString;
}

1;
