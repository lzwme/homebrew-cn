class Openshell < Formula
  desc "Safe, private runtime for autonomous AI agents"
  homepage "https://docs.nvidia.com/openshell/latest/"
  url "https://ghfast.top/https://github.com/NVIDIA/OpenShell/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "e7b80d636456eac7fea05494894f018b170d4c7b3bf89aa769e3f909554013e9"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3487186eba889c1784c59864b74b4e57c4d765dbbc6e93dd9f2c9b2790b152d4"
    sha256 cellar: :any, arm64_tahoe:       "ab9ab20b8d3d743924e3407d600009bbf80f994e6c6e7eb8a39eac17253d7edc"
    sha256 cellar: :any, arm64_sequoia:     "6617da1ca4611feca3b3f77b608791d9576ba3a1162dab2e95c9c925d2dc3031"
    sha256 cellar: :any, arm64_linux:       "6070a6852c0fdaf3c83f6bd74725b458f8d96159e32fd573d833757eb6e8ebea"
    sha256 cellar: :any, x86_64_linux:      "db468cf9de27b8b6038321ab6b8cd5158526383bb93ce88f03c1efeae42709fb"
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