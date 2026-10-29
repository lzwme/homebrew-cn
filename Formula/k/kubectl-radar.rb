class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://ghfast.top/https://github.com/skyhook-io/radar/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "4ef26f427fc44958e863e644a51bb1894bbc77b6a5d2176ad65a61b06fe0d465"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1a88521df8c4b5cc9b19e5782edeb0f41daa8b71029463d1eae4175a6d1990b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c7a39dd3ec12cfdeaab1d99457dd05d9f27104818e10a053fe9f7b822f6aa5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d43676fef7eeec0542e950c087b96ad4949fa8a9dfbb7612f059e9632a537d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e36bce53c78c8f760268eb7e099a939dc954c7f6e0310c5bf8418270ea1d9034"
    sha256 cellar: :any,                 x86_64_linux:      "6540a48ff8e6a83deafcbbe5015d0dc281857eea70a5ea9ec86e32621c92bca5"
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