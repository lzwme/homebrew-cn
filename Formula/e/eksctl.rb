class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.159.0",
      revision: "87eca01c97fbbef9964a0b138368aa850eb5aa4e"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c174f11d64f2047686dd55125dee3454d9ab2a64715d974fdb91b4a2b14f675f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92b19b913963e01c11c478292e8044e298660f8a87f95b9a424b363a3c2577e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f862c64c46c121fe52010f2c9c2fab35388ec524780740d8649cb9759b3a7e2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "87a336affb5f6033c41492849487d272106ea7c49440fb2d0878bd905418c748"
    sha256 cellar: :any_skip_relocation, ventura:        "1f545702dc7e3e4bb32ea5b861ac2aeca97ab6b5bbb44503333668efa248efc6"
    sha256 cellar: :any_skip_relocation, monterey:       "538a01069d92a99f26548304dc4bc392a590048cdb3cf658367fde3cb5407684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19973a224376ccae8de330f971866cf3d408fe7ba68c78a1de3767d69478b123"
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