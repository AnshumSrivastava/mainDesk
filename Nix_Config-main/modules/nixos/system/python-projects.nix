{ pkgs, ... }:

let
  # Fix: storage3 + supabase in nixpkgs have packaging issues
  pythonOverrides = pkgs.python3.override {
    packageOverrides = self: super: {
      storage3 = super.storage3.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [ self.pydantic ];
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ self.pythonRelaxDepsHook ];
        pythonRelaxDeps = [ "pydantic" ];
        dontCheckRuntimeDeps = true;
      });
      supabase = super.supabase.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ self.setuptools self.pythonRelaxDepsHook ];
        pythonRelaxDeps = true;
        dontCheckRuntimeDeps = true;
        doCheck = false;
        pytestCheckPhase = "true";
        pythonImportsCheck = [];
      });
    };
  };

  # Grouping dependencies by project for easy removal
  projectAlphaDeps = ps: with ps; [
    numpy
    matplotlib
    pyside6
    pytest
  ];

  discordProjectDeps = ps: with ps; [
    discordpy
    pyyaml
    python-dotenv
  ];

  warProjectDeps = ps: with ps; [
    gymnasium
    pygame
    pyqt5
    supabase
  ];

  generalDeps = ps: with ps; [
    markdown
  ];
in
{
  environment.systemPackages = [
    (pythonOverrides.withPackages (ps: 
      (projectAlphaDeps ps) ++ 
      (discordProjectDeps ps) ++ 
      (warProjectDeps ps) ++
      (generalDeps ps)
    ))
  ];
}
