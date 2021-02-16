{ dappPkgs ? (
    import (fetchTarball "https://github.com/makerdao/makerpkgs/tarball/master") {}
  ).dappPkgsVersions.hevm-0_43_1
}: with dappPkgs;

mkShell {
  DAPP_SOLC = solc-static-versions.solc_0_6_7 + "/bin/solc-0.6.7";
  SOLC_FLAGS = "--optimize --optimize-runs=1000";
  buildInputs = [
    dapp
  ];
}
