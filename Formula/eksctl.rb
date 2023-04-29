class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.139.0",
      revision: "37584337f9637482868602a94c0d263ca4190e0c"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ce6392cebcce7d15c50ce6213c20f7c46bd2144b321d4c9524a58a1767e8e4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86cbf156a88325a9b79e9b6e912ebea6eff0d7ece8bbfee1ceeaddac3c281c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b59ccd8aa671288b539f964f1a611bb13a8ff43647b730c5b59bf6aedd05698"
    sha256 cellar: :any_skip_relocation, ventura:        "249b9def29c29cb41d10475bf8a57bb441171a1048b58f7dfe0c759068237aba"
    sha256 cellar: :any_skip_relocation, monterey:       "3051b5e040f5160a5becaaa85a92896c2bbad6fcf5f96b578f5dbb6f8cc5d2a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b4d58e625b948429b45bbb084c8d2e694143891ee981d0bebb36d7a2337be51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc80caade1293158ed56c6365b5452b9acf04219d160e3ffe55bfdd20432742"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://ghproxy.com/https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

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