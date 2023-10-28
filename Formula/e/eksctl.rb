class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.164.0",
      revision: "3cdb1af9eaed027e9aa30081d8721d1ef4f629e9"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dfe71ac390c5147b6d32f14b9fe2c316b5e1c5c40e28d6f53c869ed72ad6897"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efdc9e5449f199663015ca1cac3f994ecaca5760c083d66f06766cfd84705bd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef830434e6b9968a4a1df72940a70002f8085e17dcf630445a7c5fab61725e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "68447e34a9ba97bd84cdb601755d4762722b9239b8751a4c5f91551bde486a90"
    sha256 cellar: :any_skip_relocation, ventura:        "883a14ab892906492df38c838a67a6a01d775700ffc40686145f336dd9f099c9"
    sha256 cellar: :any_skip_relocation, monterey:       "ce4222f7d85844c924a472a379d51f3828b67078097cfe6fa58ac5f58167e485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72dbb7d426f2c739fd9eda873f1a92759ea74d1eb2afbc8e66187736a7cf8236"
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