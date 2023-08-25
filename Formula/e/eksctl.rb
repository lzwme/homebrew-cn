class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.154.0",
      revision: "f73436487154cc62b67701b265766a527908cf3b"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9234cdb59d0251b143de8c886eb5b42a0363666b76687d84e8ae52f0bac7e1de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d659b6c4d3ce5c90b2fbaff55dce23ca5df5e6a503ce876c074298584395494"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a019f3ec53390bb42005f1d8d32d015afaf09070c3f155530414232b51495f15"
    sha256 cellar: :any_skip_relocation, ventura:        "f0accae920603d945506dd6eaf21c0a0ddec4049b38a093f00c77a7dee74dff9"
    sha256 cellar: :any_skip_relocation, monterey:       "c7dd270ce041d47a9934ec22e2d613a1f4dce16bf5a1d8bc2ec00059b508d5bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "51ee9226ffa000d1b48d56a0919da0297bbbddd57ec12790102f62241fd6e64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b0c8d6c8b9cef5067942bad6669328112e184b9863fcd92786ebd18d4203866"
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