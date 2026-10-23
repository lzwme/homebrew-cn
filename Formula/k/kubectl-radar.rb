class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://ghfast.top/https://github.com/skyhook-io/radar/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "015477fd4b14c22ba40464fc9c03e59595954981364054e83ee3f3eda23cbde7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d3851691bad872d75e1622e04eaba3ab43b3d3f7cef42622fe490a47887f4bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db050286e04b6400ef2f74725e3765e7ef15825a37e6692a563e9414473ed6b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76de6bcf11de342191a597670572e0af0ef2516ec52cea5c39c6638ae38c9281"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9fcc6314177572329b2092b3a5a8eca815ea4cea99a54613802a2e2aa49b970b"
    sha256 cellar: :any,                 x86_64_linux:      "b563ef7dcbd14b90df2fb6be4b1e30f2b5f0e704c51c178b4eea65e8a0abbfec"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "npm", "ci", *std_npm_args(prefix: false)
    system "go", "mod", "download"
  end

  def install
    system "make", "build", "-j1", "VERSION=#{version}"
    bin.install "radar" => "kubectl-radar"
    bin.install_symlink "kubectl-radar" => "radar"
  end

  test do
    assert_equal "radar #{version}", shell_output("#{bin}/kubectl-radar -version").chomp
    assert_match "failed to initialize K8s client",
      shell_output("#{bin}/kubectl-radar 2>&1", 1)
  end
end