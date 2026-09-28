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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd3f298efd6bc48e1ff64ce3cd9a8c9e887f24d94d3e423d76540d371418de54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec591d55941646d4b72b264fa5ec2629d7ca773e06bcb1c146a4a2895b029b25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bffd9e8d3834d32ff4a4aa512f89905bb67c63404b3f5578eedd4aec6eec7a9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1f2941055c63d177c4ea2ed74581f4f41c7432f517fffe57fde6ddf7caa4d07"
    sha256 cellar: :any,                 x86_64_linux:      "bdc81bc4fcb333fa201fcba576e431e3ec54af2063ac33e84e4433b9c9905332"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "make", "build", "-j1", "VERSION=#{version}"
    bin.install "radar" => "kubectl-radar"
  end

  test do
    assert_equal "radar #{version}", shell_output("#{bin}/kubectl-radar -version").chomp
    assert_match "failed to initialize K8s client",
      shell_output("#{bin}/kubectl-radar 2>&1", 1)
  end
end