class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://ghfast.top/https://github.com/skyhook-io/radar/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "62c2217a4f6bdbfb8254d4097f8c1cb7b559abd7b4e8fc3d705a580775140822"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83e6ea1486c5a3601f6cdcdcdcc183425c8fbf33fa738203b35cfe94cfd0748f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbf697799b2a88693ed5abfb0a11034801d759e0fbdcc7b2a56337ff7fd02626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa2b7d73e447f62d56df7b8851165747ec7ead69cb2b8b6e19dcd61bb8b9c799"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6687afeb2346fc158ace9596d5a308bde66181f28ca1e04ef2fea35fdd711f61"
    sha256 cellar: :any,                 x86_64_linux:      "18ae0a0cb19abd2107cc580f3e161dfddcb30eb45549937e912aacafefc16416"
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