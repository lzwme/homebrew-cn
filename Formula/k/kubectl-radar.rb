class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://ghfast.top/https://github.com/skyhook-io/radar/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "c96b1e15b8dba678180094372e56446e564438faea030a06913800320010d88d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55d5fda7068d40a5de2e2c8e6b1081ec7694141351d8d9fd427d41e217447556"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c817ed176e8d69e9f31905c4b9b0ea74cff327bab8010b34770f03f74d3a932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5feaeb7d65f5cb8e2bb9b9629e796d90384afc71184d6095995916771fbaa42"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21896b0d830b14c464570cb18a4883810abfa172075af05f2cda7c57202f8468"
    sha256 cellar: :any,                 x86_64_linux:      "36d5145f03d9afeb90c344a4e5c93ec73c8cec0d01ae933aed71469fdcde7f40"
  end

  depends_on "go" => :build
  depends_on "node" => :build

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