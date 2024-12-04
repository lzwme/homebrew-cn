class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.197.0",
      revision: "e96028b650e8be3c8d6781f53a2c50523b7ee82f"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e971e0090f8e11c8bca7566cc8ae37339ed6f646262032abbc4a7966f3717221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41eb69e50529b8bab9803dd50350c5b456f77c3e0030df71c1b9f4be9e9ed8c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9090aae25f52f94c0fec51e038233e8ea79ef0a0f7958026a44406c402eb2ebb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4553bcbedda1590c649e64b45774e4d1f762800c5f80c5bce92a2636b7697ae"
    sha256 cellar: :any_skip_relocation, ventura:       "ca85fcc32b77a6e98873eef8f83be54965ee7a3906b90b100fb7edb67aeb4bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79fc8b459f6b7026ac23b28913bd9134e4793f1e724599f57211af1bb5b45e98"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

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