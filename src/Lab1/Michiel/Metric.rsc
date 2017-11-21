module Lab1::Michiel::Metric

data Score = score(int score);
data Metric = metric(str name, Score score);

private str formatScore(score(2)) = "++";
private str formatScore(score(1)) = "+ ";
private str formatScore(score(0)) = "o ";
private str formatScore(score(-1)) = "- ";
private str formatScore(score(-2)) = "--";
private str formatScore(score(i)) = "invalid risk score <i>";

public str formatMetric(metric(str name, Score score)) = 
	"####################
	'<name>: <formatScore(score)>
	'####################";