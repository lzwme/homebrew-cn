class Openshell < Formula
  desc "Safe, private runtime for autonomous AI agents"
  homepage "https://docs.nvidia.com/openshell/latest/"
  url "https://ghfast.top/https://github.com/NVIDIA/OpenShell/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "e7b80d636456eac7fea05494894f018b170d4c7b3bf89aa769e3f909554013e9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f9c5efae81528206eb5ff14245d6d99665458cb6902bf9e964f3e91118c23df4"
    sha256 cellar: :any, arm64_tahoe:       "81dcdce8c6c400c5bc994d7f47a36b56481e6d289a60e1c357cb300b34bffe72"
    sha256 cellar: :any, arm64_sequoia:     "ba855b5c55fa1b374823d007a659d20c788b1e4fe462bf7b11ac92f38856b076"
    sha256 cellar: :any, arm64_linux:       "6c065124f0333c7002533c4088da217ce76386c0bcb46beb8b3436d6c1ec95a2"
    sha256 cellar: :any, x86_64_linux:      "8c11b31e08b537ed61bb9df7e9187ea81fde3b30e65390b270e09a2d19371e12"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "z3"

  def install
    # Upstream stamps the release version into the workspace at build time
    inreplace %w[Cargo.toml Cargo.lock], 'version = "0.0.0"', "version = \"#{version}\""

    system "cargo", "install", *std_cargo_args(path: "crates/openshell-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/openshell-prover-cli")
    system "cargo", "install", "--no-default-features", "--features", "defaults-without-telemetry",
                               *std_cargo_args(path: "crates/openshell-gateway")

    generate_completions_from_executable(bin/"openshell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openshell --version")
    assert_match "No gateways found", shell_output("#{bin}/openshell gateway list")

    (testpath/"boundary.yaml").write <<~YAML
      version: 1
      filesystem_policy:
        read_only:
          - /usr
    YAML
    (testpath/"candidate.yaml").write <<~YAML
      version: 1
      filesystem_policy:
        read_only:
          - /usr
        read_write:
          - /tmp
    YAML
    output = shell_output("#{bin}/openshell-prover check candidate.yaml --boundary boundary.yaml", 1)
    assert_match "counterexample: filesystem write /tmp", output

    system bin/"openshell-gateway", "generate-certs", "--output-dir", testpath/"tls"
    assert_path_exists testpath/"tls/server/tls.crt"

    ENV["OPENSHELL_LOCAL_TLS_DIR"] = testpath/"tls"
    output = shell_output("#{bin}/openshell-gateway --port #{free_port} --compute-driver kubernetes 2>&1", 1)
    assert_match "Failed to infer configuration", output
  end
end