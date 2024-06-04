class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.53.tar.gz"
  sha256 "837ad932dd33dc939c2d290634b7ed4e2bd5c1496e8a0e86941bdd69d84e9348"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b225eb9aa6cd19a858ca13e6143fae65a85367400da7b5b9a42b0887fe9b9d1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57f7dd6b8eb112966fcad6ae80525ce527cd591b580ddb9daea0a22e25b88071"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f9a2befdb97412e9ac4f262caf32c30d43cf160db32f0660093d9b7e18be861"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7db1849f266cc671e2f9bd144df9bdf097d966a4e222059a8dd7d49ffb68c08"
    sha256 cellar: :any_skip_relocation, ventura:        "e6cb3434c38bbc763370ca1617dfe99d2640530168ca728d69d2d8d520a4575f"
    sha256 cellar: :any_skip_relocation, monterey:       "b3559b99a811c58691e152ab4a5ebf98b853f4fb43c2bc4e7cd5ed1e08d4c1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e7e69f57f3661ed7111e95fbed77c2e572935cdaa8934daacae6f787892a74"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end