class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.157.0",
      revision: "1aa40b00d0e6f3bba4e37a59bd4861042fe5d7dc"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "596789e373ac5f5de74f7f26685f73e830a6c7c56b35280a410bbe891343d9ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8288214aacb517f0253b5cfc1b8e7b9c6f8d02d4b5b40c538adad2245682fa36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8ed061b819935ca6e95d8075f267541b633e78cb47d64f73f6f965198d1248"
    sha256 cellar: :any_skip_relocation, ventura:        "438381b241f6c8fa09f05a6e1e6ad123a7bea196e3ad01d3defb761a64b942be"
    sha256 cellar: :any_skip_relocation, monterey:       "dbe904e3b05c2ddc5da3f5138fd55f9bd134264f80fd07073be0ff6bbed04d84"
    sha256 cellar: :any_skip_relocation, big_sur:        "14f6acd96a284490ab03de33b8b57e098d0302867cbb0821a768b38d7a74a2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b335f306d3d8aeae3304c9773ce71f649e769ff8c076714d2c2bfcf6f2a7423"
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