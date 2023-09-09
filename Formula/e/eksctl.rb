class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.156.0",
      revision: "48d2954c5089702bbaa2b926454a305d6eeab240"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c2245e89fb64e78b3d378c2e32b654535887aa71001c7fe088d40b082133e49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97392feae24b7295d2c12c183a1a100865270bf4139685746f22d66d67cf31eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "355180da08841b394cf6cab30c06e57cb364ed7495e6714408c73cda47d689d8"
    sha256 cellar: :any_skip_relocation, ventura:        "32b7a56c0aefe58a6c147dde600f8a6ffa3971035309ebb3d41f2883f68655e4"
    sha256 cellar: :any_skip_relocation, monterey:       "5abb593ec393afa4206b6bce4e33275d9639e50c8fc253b0950266374dfe13f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c687a4ddb993e9752b7a8aa85c805cb5b119b7cb41d66d19070e8ea373b24f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7fba32adf96c5d47e9c5acb99cc0da8fdcea64cec527aac5aa1e306eb4c6c9a"
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