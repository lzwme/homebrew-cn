class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.179.0",
      revision: "b8f1ac4d77f71dbb0a355a04a074964decffe853"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ec78c7fe233a7168b4e6f1e9fe6b43763cb1a8d9a42f4514c4d642b2a401585"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38c17ec6ae434a67f335f9d349b4a9f85a586126f8dfe33b597222c9681b8fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c320e9fc74a306e4485224aefdd6bc0f6bb3f995ca980bcb54010d3cb50e9258"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1e5c22d6cdb361826496ac2d4d37334cb9edda0a312f418f2980665c8568972"
    sha256 cellar: :any_skip_relocation, ventura:        "b84e08ff0dd660735c99fa18e8d88eee695c64291a8477531f6df0a97d53077b"
    sha256 cellar: :any_skip_relocation, monterey:       "7461b89d9eb95201d51492cf52b136c467ab7caedd26518c00c7bfb7e869b8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edcefb31ddec31793838eb7ff8e9dc08f957ee52e8d01601d10f7b189986a659"
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