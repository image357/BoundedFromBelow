BeginPackage["BFB`"];
(* global definitions *)

GetResultant::usage = "Calculates the resultant of a given system of homogeneous polynomial equations";
PositivityTest::usage = "Test a given Higgs potential for postive definiteness";


Begin["`Private`"];
(* private defintions *)

PackageDirectory = DirectoryName[$InputFileName];
Get[FileNameJoin[{PackageDirectory, "config.m"}]];
Block[{$ContextPath}, Quiet[Needs["Macaulay2`", FileNameJoin[{PackageDirectory, "Macaulay2.m"}]]]];
Block[{$ContextPath}, Quiet[Needs["Positivity`", FileNameJoin[{PackageDirectory, "Positivity.m"}]]]];


(* ---------------------------------------------------------------------------------------------------- *)
(* function: GetResultant[...]                                                                          *)
(* description: Wrapper for similar functions based on different packages                               *)
(* arguments: polynomials - list of polynomials                                                         *)
(*            variables - list of polynomial variables                                                  *)
(*            parameters - list of polynomial parameters                                                *)
(* options: ResultantMethod - "Macaulay2" name of the method to calculate the resultant                 *)
(* return value: <| "ErrorCode" -> 0 on success, -1 on error, "Resultant" |>                            *)
(* ---------------------------------------------------------------------------------------------------- *)
Options[GetResultant] = {
	ResultantMethod -> "Macaulay2",

	(* Macaulay2 Options *)
	ScriptName -> "script.m2",
	OutputName -> "script.out",
	RationalAccuracy -> 0.001,
	IntegerRing -> False,
	Algorithm -> "Poisson"
};
GetResultant[polynomials_List, variables_List, parameters_List, opts:OptionsPattern[]] := Module[
	(* local variables *)
	{retval, allowedmethods}
	,
	(* consistency checks *)
	allowedmethods = {
		"Macaulay2"
	};
	If[MemberQ[allowedmethods, OptionValue[ResultantMethod]] == False,
		WriteLine["stderr", "error in GetResultant: unknown method"];
		Return[<| "ErrorCode" -> -1, "Resultant" -> Null |>];
	];

	(* code *)

	If[OptionValue[ResultantMethod] == "Macaulay2",
		retval = Macaulay2`GetResultant[polynomials, variables, parameters, FilterRules[{opts}, Options[Macaulay2`GetResultant]]];
		Return[retval];
	];

	(* default return *)
	Return[<| "ErrorCode" -> -1, "Resultant" -> Null |>];
];


(* ---------------------------------------------------------------------------------------------------- *)
(* function: PositivityTest[...]                                                                        *)
(* description: Wrapper for similar functions based on different packages                               *)
(* arguments: potential - Higgs potential                                                               *)
(*            variables - list of real scalar fields                                                    *)
(*            parameters - list of Higgs potential parameters                                           *)
(* options: TestMethod - "NumericalResultant" name of the method to test for postive definiteness       *)
(* return value: <| "ErrorCode" -> 0 on success, -1 on error, "PositiveDefinite",                       *)
(*               "PositiveSemidefinite" |>                                                              *)
(* ---------------------------------------------------------------------------------------------------- *)
Options[PositivityTest] = {
	TestMethod -> "NumericalResultant",

	(* BFB`GetResultant *)
	ResultantMethod -> "Macaulay2",

	(* Macaulay2 Options *)
	ScriptName -> "script.m2",
	OutputName -> "script.out",
	RationalAccuracy -> 0.001,
	IntegerRing -> True,
	Algorithm -> "Poisson"
};
PositivityTest[potential_, variables_List, parameters_List:{}, opts:OptionsPattern[]] := Module[
	(* local variables *)
	{retval, allowedmethods}
	,
	(* consistency checks *)
	allowedmethods = {
		"NumericalResultant"
	};
	If[MemberQ[allowedmethods, OptionValue[TestMethod]] == False,
		WriteLine["stderr", "error in PositivityTest: unknown method"];
		Return[<| "ErrorCode" -> -1, "PositiveDefinite" -> Null, "PositiveSemidefinite" -> Null |>];
	];

	(* code *)

	If[OptionValue[TestMethod] == "NumericalResultant",
		retval = Positivity`NumericalPositivityTest[potential, variables, FilterRules[{opts}, Options[Positivity`NumericalPositivityTest]]];
		Return[retval];
	];

	(* default return *)
	Return[<| "ErrorCode" -> -1, "PositiveDefinite" -> Null, "PositiveSemidefinite" -> Null |>];
];


End[];
EndPackage[];

