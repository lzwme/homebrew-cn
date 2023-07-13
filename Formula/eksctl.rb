class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.149.0",
      revision: "97ec4b2d946c101db9ea26cd61dbac35a9a7fc05"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c50ae85a4ac08f5918f76b6c9f2ff1b2832c0b67d16f1b5f111c025cb5b7596"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c954430a1a929091d66e041c02c8874ccc1a0ecd653961ba96829122354b4b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18113df5cd5536e29cfc1c2c6138ed3abab8bcbafead85500a675f7756632e21"
    sha256 cellar: :any_skip_relocation, ventura:        "f58e38f7286fdd03c269370f1c0c4d11624d44481ba00e99fdeec1b6ac1bad18"
    sha256 cellar: :any_skip_relocation, monterey:       "8ef16d2d76eb66c43b08abd1e35fd013c9a79990a7cdbc8723cb12c04a372195"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab4ba17c9aa28c2f0c370a32ed2b75d7aab4d563237b6d699a1def22f8c2b9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b28a9f8e78c56f0f1cf7e42d31ec07611ad5959070803e0c1943314040b3773"
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