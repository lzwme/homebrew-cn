class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.25.tar.gz"
  sha256 "bb242787dcc299b86a981f326ea59596cb244ae32a0227cf9f466b05bb3cd3ec"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af069eabc3be5d1d51b1db25d2579eaf1859b99bddd38599dab474d8951a3a2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73a916b5f23cdaf8fd2ff7f71f98c53900117c0b5351883130f072ba657f145b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ecd02fb515a6656966b039e8306d0bce5ff910d47b18fc38581dc8e4ab3bf7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "558b44e1b96af657fe79cf509a58e540cc65e1619b7c7d33f251e78331894235"
    sha256 cellar: :any_skip_relocation, ventura:        "b20e37ef34c58b99cf82fa5cfcb9f90a702ca711aa12df614c02f54dee5025e7"
    sha256 cellar: :any_skip_relocation, monterey:       "012cfbce200d513968003f358a4953d9462d4512d5fd5b1328dad2104206040a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1813d928c1997f45c33b10fade8f4aed3485dad949f7ce49df96ed04042449a"
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

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags: ldflags),
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