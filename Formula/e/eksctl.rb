class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.170.0",
      revision: "d03c12312e1c770b6a0254c8756030913af3b67e"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbb902884fab5db7351cbbc314b636445ac61a1641eee7e181c8e6df62c0b48b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ed71ac2b30e0f5058f30339ed495b97fbed89c8ebf61f1ad5a862b0f6c487eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0e553149d0da6f9327d243dab320c1f5b6bfa5f68668131460d1f4d524234d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "16d6299d6b3fc59b1b922a0576fbb86cac9eda098cfc82737cef899e5a23b62c"
    sha256 cellar: :any_skip_relocation, ventura:        "5400f5269baa82ac1c40887fd69b5619328044fda075a46ef23035fa42efb292"
    sha256 cellar: :any_skip_relocation, monterey:       "5daff9ee308a0b4fb58cdf6a5961f7be163b515f0f4638e73f132a4c7cb38e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01e5429c21cbf247d244343c8f4b980927d551ee3986cc5a99c0ba7779f443b"
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