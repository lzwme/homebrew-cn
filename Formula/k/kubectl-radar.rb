class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://ghfast.top/https://github.com/skyhook-io/radar/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "9f7f3636ce4da5b360ab91bfc46a882b30c35a63f6dddf14b2ec2ed9f0bb8dc0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5544f44790f02fcb73f15b9e4e37c8a7d75298cd3644497de01e526c29632059"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8788a4691e0fcd0d1e4d190511540f51eeb36e43effc0a0c7e6bc72d492233fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8ebbdac34495c9421b9462eeb00499d27649fae7d79b0fe61b1b0b1a780c204"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d054e28dd7d9656b99cc6d21d5849852dd784ae88f42896d3b1a400fb527ce25"
    sha256 cellar: :any,                 x86_64_linux:      "3ba01873e12512aea68115f6dcbf5277c626da737d96fa5eb1b6f1f78ce8e862"
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