class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.125.tar.gz"
  sha256 "fe9b5d294810ecb63d3d9b832962222fa49f034f45555d9116ca316396d6e23c"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8944c7ed1125db06c3a814d83444f5274eeb40fc991f300df617a6e6690fcc28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8944c7ed1125db06c3a814d83444f5274eeb40fc991f300df617a6e6690fcc28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8944c7ed1125db06c3a814d83444f5274eeb40fc991f300df617a6e6690fcc28"
    sha256 cellar: :any_skip_relocation, sonoma:        "cea75eafee2c1ff9eac8df9c58a574d56b3dca9277b6848049e2d6e5b1dc794e"
    sha256 cellar: :any_skip_relocation, ventura:       "cea75eafee2c1ff9eac8df9c58a574d56b3dca9277b6848049e2d6e5b1dc794e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3212811a3bcc6f983b2637e676e663973d0123bf669f70b4568703f5fdc006c"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
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