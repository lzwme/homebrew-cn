class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.186.0",
      revision: "c66758141cb63f44d22181bdcc57908c0629a640"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "806ce2676653fc05fd87a757da637b9d481a4ced555d2cd35c635fd2e6549ea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54adaeb78570b2925f614e619f5c3bb9ea1752f929deba897c9427ec3ee02330"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d7f8a363976f003cef89630b37d76c6c021ca446170b25440bffb6d3d8c8bf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1c131e0fda122a284be8aacf4dfb4bc65065a350611467bf88912fe5e4743cb"
    sha256 cellar: :any_skip_relocation, ventura:        "0dc6f46d1e240e53199a2217b012692f801ddedb68468184cee90d87a41d3e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "5e305fe524b9d2663ec1f55fdf49cb02ec73767c8cf4a2300d94bc0180ec5f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee433e98d549de9df8cf357411f1f0fd62c9a5dd0fa1cbb368c9377f0e567583"
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