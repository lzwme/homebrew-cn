class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.1.tar.gz"
  sha256 "c15a66ca5081fb7f68e5c2d762ddf304b9086f5c82f0d2910c78869d01b78395"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c38c38562d4e1cd005341393578b16577138f3a158d2bb052cde38b2e2efdaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da2006fa3a1723f838aedd4ea3415bce343d07a19b6890fa0e80306b882323c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ade981a8803064e24a786d75a12e65dd7fdfa86117e585be814bf89cf495554e"
    sha256 cellar: :any_skip_relocation, sonoma:         "329f36c52389e316b86d7b005862397b8c5232a122c86ba6b205de8768b5a634"
    sha256 cellar: :any_skip_relocation, ventura:        "deed867c30fccee3d8b08fcccdf4f7b1832d0cc96e6c47d634e72e9ed0b83ef8"
    sha256 cellar: :any_skip_relocation, monterey:       "1782a5e4f3cc2d1bddaf7cf6f0a64e3e5c7449c82399661787694d8dc6397391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a19c6db074351b78cf2d61a4858eed6d03039790b16aa714eefbf43b90e78ce"
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