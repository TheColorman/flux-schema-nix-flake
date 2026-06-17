{
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  lib,
  nix-update-script,
  stdenv,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "flux-schema";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux-schema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qmid2/nxmlqJtH87Dd98o2GdryjIcsL7s94hadW5hBs=";
  };

  vendorHash = "sha256-vtEc3ZWU80K4p2aNKgamk/J/i4b/xUOVbu+IxXO1vF4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/flux-schema"
    "tools/schema-gen"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/flux-schema";
  doInstallCheck = true;

  env.CGO_ENABLED = 0;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd flux-schema \
        --$shell <($out/bin/flux-schema completion $shell)
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flux CLI plugin for Kubernetes manifests validation against JSON Schemas and CEL rules";
    homepage = "https://github.com/fluxcd/flux-schema";
    downloadPage = "https://github.com/fluxcd/flux-schema";
    longDescription = ''
      Flux Schema is a CLI for validating Kubernetes YAML manifests against JSON
      Schema and CEL rules using the same evaluation semantics as the Kubernetes
      API server. It ships as a single Go binary with a built-in catalog
      covering Kubernetes, OpenShift, Gateway API, and the Flux ecosystem CRDs.
    '';
    changelog = "https://github.com/fluxcd/flux-schema/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ TheColorman ];
    mainProgram = "flux-schema";
  };
})
