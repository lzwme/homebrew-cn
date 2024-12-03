class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.196.0",
      revision: "9be90107f4f5ce2946ae1f02503f79280f20096b"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405c79b6ab97e89b9d796168c4e64104cc209ed56dbf9e24e6fd76fd0dcf5507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba57f031d2c39bda2082c423c49b38b86dff643f1d53fc578d239ed1c530a56c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e42810e444a6794387b4b6038bfa3894a87e40f57a6b91ccb1fc364e4aacda4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "237048290edfa646212784a89c4e122cce794729f28c0eb105bb3b33f3abc642"
    sha256 cellar: :any_skip_relocation, ventura:       "bce44a3112e192df3e7f36ae548a0e8df0f7720fb628423adcb53762a2905129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac0e1f687b68b7d07d9662a424925ab070a30c52b137ae1ea2920f636bd3889"
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