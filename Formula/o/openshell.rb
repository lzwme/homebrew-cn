class Openshell < Formula
  desc "Safe, private runtime for autonomous AI agents"
  homepage "https://docs.nvidia.com/openshell/latest/"
  url "https://ghfast.top/https://github.com/NVIDIA/OpenShell/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "0ea7e81c5980680d4e65ad292a77ed3fc992a3cf5414bb99669f5c57d9ceb551"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "890457ce849cc38af861eca09f3a1c5e4ae9c11da60f9af7ae040a04c277f364"
    sha256 cellar: :any, arm64_tahoe:       "726654bbd98c91961e186d03df2e77fef2a0b9ea3a8a7a689017dcd34a08480e"
    sha256 cellar: :any, arm64_sequoia:     "0735145cba24b3f18e02787ccccdf6d747d3192d0650094ef43055082a0ede8f"
    sha256 cellar: :any, arm64_linux:       "e08fb4e45922e66b8ed35a8f269110be2e56ad48d3d34b5dbf6510d7a6a89aea"
    sha256 cellar: :any, x86_64_linux:      "e25ff7231c56129ba48a17adc807daeeea2f378d32a76e3f32352fcafd51cb54"
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