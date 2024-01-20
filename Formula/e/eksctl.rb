class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.168.0",
      revision: "6915dac673f296d9765377bd36a8179af5bb9737"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ebb54258d3b9106ef1975df5d0a260f9f5e3eed303fa7b838d02dacb4ed7fe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "072024e5f479771738d9c8709b6877fd220b2bfbe9661f8dede15ce05dd375a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abaefe4831616038ffc695ffb7987d42e2503acb40e366518a0ef8e1482c5bfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "c27fca1ac0f9b05404db0a7a9a507239cfd725a2efc55d42c968d892411188f3"
    sha256 cellar: :any_skip_relocation, ventura:        "e44072ee9bc5a47373f841e944da1032acf56f314976d9718a635f89772f8dfd"
    sha256 cellar: :any_skip_relocation, monterey:       "a0f0312a12e4fbe6c28cd26d3dad4c18c8e44e77447514086b10b90894c0a1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3cc6e8bea70309498421bf2e4c41584e612019ddf888f0223b2714c67f861c"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}eksctl create nodegroup 2>&1", 1)
  end
end