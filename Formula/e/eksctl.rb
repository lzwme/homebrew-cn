class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.163.0",
      revision: "e4222edab150fdbde364adce6576ea74694fb471"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc5c9f7179ad85a7a4d3e2301da808f942455c3665e94ae58c6e5e36a2ba2f8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3c9ef362f080acdc8299cc40450edf31e9c004a69aff4e817aee710b400c6a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5877a36d6164f5b693b3cd3bb4739044d53dd29d05eccda9ee35139df381114d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7058dd9f3f114442bf122b0e17f8a09538ada422dff1721f0627df983aca169"
    sha256 cellar: :any_skip_relocation, ventura:        "ee216def192543e22d1fb0641893163f313a9d886c8125afce96429827c52e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "ccc3b055b296334447918cbe13e07161fdb6d8f51a25d030bc835fb306383d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "903d9241a9407464fa0cc3c46e4a4778130aa2f0acb17be3be1800708fb0ff4d"
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