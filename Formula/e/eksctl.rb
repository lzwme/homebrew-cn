class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.188.0",
      revision: "65f8193d0a1978308f6d0ef1853fe38f56dad128"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff422dbdbea3bae80172954dbce849698af075996aee88b71ff6d3fce728c0dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a2c92d29cf3f3b4ea3711f15658df05e37a85dbdbbb968d6f3f8511aecba18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1433ea52c3d91afa3fae87591013fa04957155829b4d7e972239edfd697c9052"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5d38556ccf5b6e5b91059d61c970c5442a59dff848111f57bcce34ac06c3eaf"
    sha256 cellar: :any_skip_relocation, ventura:        "1a125dd98f6976789523cb1c256529134d3c23d55ed8f88023bfadb5f38aa993"
    sha256 cellar: :any_skip_relocation, monterey:       "c92776d444f2f020228bc73b68376c41c666d2d4f6a8b082246078124b8796b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1270b527b86b308b13a736a0778aa986bf4095d9d2d09dc452c4f0bcf966459"
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