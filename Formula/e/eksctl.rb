class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.169.0",
      revision: "1c8cc6244ffeb0188630702e7909b08759ea5f93"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8c352c3ec0792ae3a641d85f267a583a2bdf5985b0b4b392edd72de5832ccf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2febde6c237249beadf4212ec6c890ee300710fcfb3a4aaeadbe22d2166c81c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caa68757d39f1d68804a91055a9379f83e8333040d0fd1bb98c2a3e2edd27862"
    sha256 cellar: :any_skip_relocation, sonoma:         "180bdf7778ffb2af02e3c3304b8b439c0170e7c8f38b150db45049f0d4389b84"
    sha256 cellar: :any_skip_relocation, ventura:        "da733fe075a527ec2683c9a19fdf607ed3c3e1a14c75cd0262345993a6e33609"
    sha256 cellar: :any_skip_relocation, monterey:       "c0ccdb521701b7d405b5c71904770cdfe1897df061fab1aaac062d03ea680ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e2536fe43c108f2e77172205909f784c93198596d596513670399b755f6123"
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