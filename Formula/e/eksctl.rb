class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.184.0",
      revision: "a6bc00f420ed660070285602c5e07110640e5f56"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab88cbdd3d497c73fa1854c5bb97ecdd64ecc9afa3c0c10d704fea606d12c34a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9bbaf1a2be65689dd94531d330e61c50e00ab79c2183cf060c16cc7bfca5e9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87de5d7bfe94054238a849eb992a42ed003f7573680945678569549b5cba8edc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d22e11cd2cb1b8407e50e91a45de09dfd124901ab5941f13bec62fa425fda460"
    sha256 cellar: :any_skip_relocation, ventura:        "c7beeca62ed6db2520b00a8104c2659a8ba7ea0fae5d5d2a7641e77da1a62887"
    sha256 cellar: :any_skip_relocation, monterey:       "d6b499abcb23d3da4c039e2a76516c67bb782e01d403240ed8e353589884d262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5936f85b448f9a2e1dff59b4d23ddea7cb86783fc1628f87ab9a6384ca46daa"
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