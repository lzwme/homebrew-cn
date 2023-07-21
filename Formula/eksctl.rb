class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.150.0",
      revision: "cdcf906b76728da669738accc15c118125408c5d"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4c503b629a1d94aba36b6ed9ac2bf6d305f0da54f17a6539aaa32c0b62b5571"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "650483bce88cc31d93baa63bedc000850c32a02c3b870841586ffffbc26c578f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38d239fdd826543a11eb80603b91d8e9fcdfdf51a92fe4f73322f78d67a74d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "236b79d6b3513ce23d92139be8c7d504baaa440a1108d77115d4dc0d4b6a0f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "a93d3f26d80179c8b81d35c174b83bf0582009ed592493ef2d2a012b6e1ed5b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9740c104276b1103c1745b21e9ba611edc5826335b77512e550bb9e087f80eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a87e2058a5e5d9b56cc158b4d31ec070bcf847bf17b28d57b3c4a6c7a5d94b07"
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