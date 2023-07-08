class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.148.0",
      revision: "5c3b271edfbe12daa248a7945c676009b90cad5a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "278b2c7650cf6d14a3e096c378029141c23512fc63d58490725d9bdf21b30b9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5063bc9725a941d35788a919f7edebfa92297d81c30a923b9570feeb7933b64a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f11e1000f65fab4e143bb6fa7aeb4039d92a2e2904a2250ba4ea83c9a8c7ddd4"
    sha256 cellar: :any_skip_relocation, ventura:        "6037ece24eb22086f63cd445cf58087f1b3bfc2309dfa149ebdf1ec9ff7ba2eb"
    sha256 cellar: :any_skip_relocation, monterey:       "4585488f56078dde6568da7901900054a33cdeb1d606efb5e97e78f1a3ff2814"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fa749907cca3855e4fd322eaf2d3d4a4d3090f2ca23c938eb76567406e45c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d947d41ee5551c38b34db698b18f8fc7d5b1589826972e05dc3f2b90cc33d9e"
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