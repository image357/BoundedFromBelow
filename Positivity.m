BeginPackage["Positivity`"];
(* global definitions *)

ReducePotentialToPolynomials::usage = " Will reduce a Higgs potential to its system of polynomial equations to decide postive definiteness";
NumericalPositivityTest::usage = "Tests a given Higgs potential with numerical parameters for positive definitness";


Begin["`Private`"];
(* local definitions *)

PackageDirectory = DirectoryName[$InputFileName];
Get[FileNameJoin[{PackageDirectory, "config.m"}]];
Block[{$ContextPath}, Quiet[Needs["BFB`", FileNameJoin[{PackageDirectory, "BFB.m"}]]]];


(* ---------------------------------------------------------------------------------------------------- *)
(* function: ReducePotentialToPolynomials[...]                                                          *)
(* description: Will reduce a Higgs potential to its system of polynomial equations to decide           *)
(*              postive definiteness                                                                    *)
(* arguments: potential - Higgs potential                                                               *)
(*            variables - list of real scalar fields                                                    *)
(*            parameters - list of Higgs potential parameters                                           *)
(* options: None                                                                                        *)
(* return value: <| "ErrorCode" -> 0 on success, -1 on error, "Polynomials", "Parameters" |>            *)
(* ---------------------------------------------------------------------------------------------------- *)
ReducePotentialToPolynomials[potential_, variables_List, parameters_List] := Module[
	(* local variables *)
	{numvars, eigvalpardummy, Qtensor, polynomials}
	,
	(* consistency checks *)
	If[Length[variables] == 0,
		WriteLine["stderr", "error in ReducePotentialToPolynomials: no variables given"];
		Return[<| "ErrorCode" -> -1, "Polynomials" -> Null, "Parameters" -> Null |>];
	];

	(* code *)
	numvars = Length[variables];
	eigvalpardummy = ToExpression["eigvalpar"];

	Qtensor = D[potential, {variables, 4}]/4!;
	polynomials = Table[
		Expand[Sum[
			Qtensor[[ii,jj,kk,ll]] * variables[[jj]] * variables[[kk]] * variables[[ll]]
			,
			{jj,1,numvars}, {kk,1,numvars}, {ll,1,numvars}
		] - eigvalpardummy * variables[[ii]]^3]
		,
		{ii,1,numvars}
	];

	Return[<| "ErrorCode" -> 0, "Polynomials" -> polynomials, "Parameters" -> Join[parameters, {eigvalpardummy}] |>];
];


(* ---------------------------------------------------------------------------------------------------- *)
(* function: NumericalPositivityTest[...]                                                               *)
(* description: Tests a given Higgs potential with numerical parameters for positive definitness        *)
(* arguments: potential - Higgs potential                                                               *)
(*            variables - list of real scalar fields                                                    *)
(* options: None                                                                                        *)
(* return value: <| "ErrorCode" -> 0 on success, -1 on error, "PositiveDefinite",                       *)
(*               "PositiveSemidefinite" |>                                                              *)
(* ---------------------------------------------------------------------------------------------------- *)
Options[NumericalPositivityTest] = {
	(* BFB`GetResultant *)
	ResultantMethod -> "Macaulay2",

	(* Macaulay2 Options *)
	ScriptName -> "script.m2",
	OutputName -> "script.out",
	RationalAccuracy -> 0.001,
	IntegerRing -> True,
	Algorithm -> "Poisson"
};
NumericalPositivityTest[potential_, variables_, opts:OptionsPattern[]] := Module[
	(* local variables *)
	{retval, polynomials, parameters, eigvalpardummy, charpolynomial, reigval, nreigval, zreigval, posdef, semdef, testequs}
	,
	(* consistency checks *)
	If[NumberQ[potential /. Table[variables[[ii]] -> RandomReal[], {ii, 1, Length[variables]}]] == False,
		WriteLine["stderr", "error in NumericalPositivityTest: potential has analytic parameters"];
		Return[<| "ErrorCode" -> -1, "PositiveDefinite" -> Null, "PositiveSemidefinite" -> Null |>];
	];

	(* code *)

	(* make polynomial eigenvalue system *)
	retval = ReducePotentialToPolynomials[potential, variables, {}];
	If[retval[["ErrorCode"]] =!= 0,
		Return[<| "ErrorCode" -> -1, "PositiveDefinite" -> Null, "PositiveSemidefinite" -> Null |>];
	];

	polynomials = retval[["Polynomials"]];
	parameters = retval[["Parameters"]];
	If[Length[parameters] != 1,
		WriteLine["stderr", "error in NumericalPositivityTest: more than one eigenvalue parameters"];
		Return[<| "ErrorCode" -> -1, "PositiveDefinite" -> Null, "PositiveSemidefinite" -> Null |>];
	];

	eigvalpardummy = parameters[[1]];

	(* calculate charactersitic polynomial *)
	retval = BFB`GetResultant[polynomials, variables, parameters, FilterRules[{opts}, Options[BFB`GetResultant]]];
	If[retval[["ErrorCode"]] =!= 0,
		Return[<| "ErrorCode" -> -1, "PositiveDefinite" -> Null, "PositiveSemidefinite" -> Null |>];
	];

	charpolynomial = retval[["Resultant"]];
	Do[
		polynomials[[ii]] = Rationalize[polynomials[[ii]], OptionValue[RationalAccuracy]];
		,
		{ii, 1, Length[polynomials]}
	];

	(* find real eigenvalues / roots of the charactersitic polynomial *)
	reigval = eigvalpardummy /. FindInstance[charpolynomial == 0, eigvalpardummy, Reals, Exponent[charpolynomial, eigvalpardummy]];
	reigval = DeleteDuplicates[reigval];

	(* select negative (n) and zero (z) eigenvalues *)
	nreigval = Select[reigval, (N[#] <  0) &];
	zreigval = Select[reigval, (N[#] == 0) &];

	(* test negative eigenvalues for H-eigenvalues *)
	semdef = True;
	Do[
		testequs = Table[(polynomials[[jj]] /. eigvalpardummy -> nreigval[[ii]]) == 0, {jj, 1, Length[polynomials]}];
		reigvecs = variables /. FindInstance[Apply[And, testequs], variables, Reals, 2];

		If[N[Total[Abs[Flatten[reigvecs]]]] > 0,
			semdef = False;
		];
		,
		{ii, 1, Length[nreigval]}
	];

	(* test zero eigenvalues for H-eigenvalues *)
	posdef = semdef;
	If[semdef && Length[zreigval] != 0,
		testequs = Table[(polynomials[[jj]] /. eigvalpardummy -> 0) == 0, {jj, 1, Length[polynomials]}];
		reigvecs = variables /. FindInstance[Apply[And, testequs], variables, Reals, 2];

		If[N[Total[Abs[Flatten[reigvecs]]]] > 0,
			posdef = False;
		];

	];

	(* return *)
	Return[<| "ErrorCode" -> 0, "PositiveDefinite" -> posdef, "PositiveSemidefinite" -> semdef |>];
];

End[];
EndPackage[];

