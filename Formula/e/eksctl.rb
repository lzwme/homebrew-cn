class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.165.0",
      revision: "2064e6b321ed6a15804a8ef29c6d1b56e75bcf57"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85e6e6818ba65d6c0d93642d97f1ce67ab2888c57bc3ca1a3eb592bf2201fafd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca11b0e915ce1bd7d743d01a27235d4dd37d64a6b1c84718d96d5f52b586e95c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7003eb55ac67a7cf532e44d98fd1d83217a07c9af903eeedcce82ef55b896bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ae715acfa5b18c38b5ee38109100552dbb55a735bdd46d4fa827686ba531f87"
    sha256 cellar: :any_skip_relocation, ventura:        "e71cdaa6fd27361d74febd5004715b349bedb613edcbda038582b33ba081d4e1"
    sha256 cellar: :any_skip_relocation, monterey:       "42485ad4fc59d9c9afc6adec4b3792d4c6cb4ae57ab17042778985dc8559f631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1edf64bef236fef2ab5fb8e355d3da57bff0ac06176ddc3f7b30a10aa8852612"
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