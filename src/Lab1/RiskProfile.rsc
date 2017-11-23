module Lab1::RiskProfile

import IO;

data RiskProfile = profile(real low, real moderate, real high, real veryHigh);

void printRiskProfile(RiskProfile profile, str name) {
	println("Low <name> percentage: <profile.low> %");
	println("Moderate <name> percentage: <profile.moderate> %");
	println("High <name> percentage: <profile.high> %");
	println("Very high <name> percentage: <profile.veryHigh> %");
	println("Total <name> percentage: <profile.low + profile.moderate + profile.high + profile.veryHigh> %");
}