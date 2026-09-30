class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.15",
      revision: "16cfe102f11551a6455fe9bf8e37d7083da90484"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb81f368edc28b3b74a169c85131ef2ee70c04cb3b94d268b6f376cc3d94ae42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f031adc23e9beefc343d1da5fa190b776feddba6e0f713731eec0987d467ec53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f236fcf78e3fabf58847a7efcc9dc8742b083d4d642ee211c490e71bf28138a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c2a4d9ccb97c987367ffd8c7a18c952857711a8b3e4d54788efb2a4ec30a28b5"
    sha256 cellar: :any,                 x86_64_linux:      "8c4aa223ed3a0ff1ec53cabd3f60ac552ccfe4a6febae062f4c775af82db44b3"
  end

  depends_on "go" => :build

  # `test do` block downloads framework artifacts and scans a remote URL
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra)
  end

  test do
    manifest = "https://ghfast.top/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end