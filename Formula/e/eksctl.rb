class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.211.0",
      revision: "ceeab7032abb249e8891a58e6c76299bb137a606"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe283821dae4845536b9790987d554f1ca4a807335dfc09d4091e1be22a5afbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe3f5f2b8f3f04c75037c61f680ef349bfe834b82c296e5501b267e7a5f12c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22ea8485bd8aad7c91f8e47a28ee669dcfdb11a6e41ae814cd1716e40b287720"
    sha256 cellar: :any_skip_relocation, sonoma:        "671687ff5cec4e70e2025f2cec11ac8b6ef48b0c364c6fa8a4a269b456d46efe"
    sha256 cellar: :any_skip_relocation, ventura:       "85c0d4e785be2607d716d090c018a36791249f583a3340813a446da30c6f8a41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34a90a25c18d383f64e28f42f2d546776d299d43d7550a13768b0445c578943b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c85c50f201a2e90675563b16fc1bab3432f37cfc0ac3ba2d9c5de0a0be5bed"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end