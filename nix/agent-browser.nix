{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-browser";
  version = "0.38.1";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C+XplCHOdFDQGPUnrCDuq7U4LkAX0QB3fC4uVA8o11w=";
  };

  cargoHash = "sha256-Ei26Iz0qMqayucULLCSwN+fjw0VJ3S2L2A4vGhfYGqI=";

  sourceRoot = "${finalAttrs.src.name}/cli";

  postUnpack = ''
    chmod -R u+w "$(dirname "$sourceRoot")"
  '';

  postPatch = ''
    mkdir -p ../packages/dashboard/out
    echo '<!DOCTYPE html><html><body><p>Dashboard not built. Run: cd packages/dashboard && pnpm build</p></body></html>' > ../packages/dashboard/out/index.html
  '';

  preCheck = ''
    export HOME="$NIX_BUILD_TOP/home"
    mkdir -p "$HOME"
  '';

  checkFlags = [
    "--skip=doctor::helpers::tests::test_which_exists_matches_common_binaries"
    "--skip=doctor::helpers::tests::test_which_path_returns_an_existing_binary"
    "--skip=plugins::tests::credential_plugin_failure_does_not_echo_plugin_error"
  ];

  meta = {
    description = "Agent-browser compatible CLI vendored by terminal-browser";
    homepage = "https://github.com/vercel-labs/agent-browser";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "agent-browser";
  };
})
