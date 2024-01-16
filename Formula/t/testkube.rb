class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.23.tar.gz"
  sha256 "3ee40266b67a86c32e175e901a96bfce23811533e7e51c66b578d16b810b658a"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f00cf26ddf7c1fe6352aba66010456ab7e5893410fe2fbae941bc2060d2b180d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df0e4bebdb770fbb02fd3bec0a461e2c8a36e1e1fce7db9a5333e1253af5b671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "439d1c2c2a5ad29b4610204557a45d3b837a43f8898cad89e632d4b81e572672"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f4cf4564717ab15285f60adcee9d41abc6bd031f929da5297c79ffe3378cbdd"
    sha256 cellar: :any_skip_relocation, ventura:        "d13b3f130cb8d013726ab08061fa1783008b3d99de81f8a5da1a61a9583a97a6"
    sha256 cellar: :any_skip_relocation, monterey:       "00779a7b26242064b6402cb5fb69ce620676d4e3cbd11f4c763b4d97e6705a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e7e62eed4cdb6001384b27dc4c53840e1198f6696fc3606585bc23953ab5c45"
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