class Openshell < Formula
  desc "Safe, private runtime for autonomous AI agents"
  homepage "https://docs.nvidia.com/openshell/latest/"
  url "https://ghfast.top/https://github.com/NVIDIA/OpenShell/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "eb6a8aac8e93951dde74234091e893e81309763d2ac161bd76bbff4822de1cf8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fba10fe68279064604dc34d89543c14d45208db0833300006d4441af03379e87"
    sha256 cellar: :any, arm64_tahoe:       "4f7d8c8907eb39ef413495a9c203373ab711197840b961f71f64d8fd4fe2bdcf"
    sha256 cellar: :any, arm64_sequoia:     "3f73abda2b40dcb1dac12a08dfff0e905e674120c6ec7dfa94bab8c9e872fef1"
    sha256 cellar: :any, arm64_linux:       "0e4826cac6194d974eac105e4f4e00cf44b62d49278442ca6c53e7948dc37ab8"
    sha256 cellar: :any, x86_64_linux:      "fec36579f0af1f375ec1f99b455948b95005219001131376e59ff5a1081beef4"
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