class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.142.0",
      revision: "871f32d9fe4549f7f39155733fb7c4a2b6b7f66c"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3343775c57e252d55f6a806c5e778b48c97356204362010513f431bb269c7836"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b285e1446668abc581fb717dc7083e83d00a92716ed42fc7940ce6cc649eb5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79b2ac490157e1a6e748c9f06c17b572f117dcff179261d3cefbcef6970093fa"
    sha256 cellar: :any_skip_relocation, ventura:        "f83157a43d3976ed759d775fb0388d89306a45eb95bffa948260eb16f5412ff8"
    sha256 cellar: :any_skip_relocation, monterey:       "b535325f1a29f5748e147974b363ffacc00afe237ca45ace8024768e25d8675a"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f5830a7039ed92463c7c41bfd0924cca077870bf58d2694aaf845f4757ec68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0797b3be808b33c8054fab59a0ecd6c91c471c18ed45710633214574bb50c243"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
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