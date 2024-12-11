class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.198.0",
      revision: "8c015c84d078e3bfc469ae386e30c1eb8f0a2fa0"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88dae27491a4f32a5c18381e30376d58ee7ab0b7f7835d68cae62b99c86e03ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb71d27cf80921730b6e92722b9834fd3b78078146593ce2712f8b39f0ea6a6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90c4f61301e3251949fb94e0bb99a08c2fd02230958af862c58e1e68e22e896f"
    sha256 cellar: :any_skip_relocation, sonoma:        "83c45a4d0850baebea7ccabd76c010d646b14f268dce79e87414088e1c0b21b7"
    sha256 cellar: :any_skip_relocation, ventura:       "0f8204aafa25be9cf10a0efcc438446de834164199d582d648e390243bce665c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b26c6bd1f34eb1ae7677f923a16df713fe3c744aee259ac540c742fa5743401"
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