class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.32.tar.gz"
  sha256 "a7e0a84327c17316f204018bc86920f52337ff0e5be2588257fbd3dbc734e308"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3ceb5a37de13059ebc27312cf3667276c9ba017d58f85b8d5e798213cdf28c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f672703e97d00971fd5f3acc850a3fb9a299a061a1240fbe69ea76e3f75d1ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa697b562a71a299245295d1596d5aa494050b53a10fb32f12f86318a8ff30ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0ca2e8cc68c86ead5676bbefe1baadb2180db4e5c79aeebb8c8978f688f3fd2"
    sha256 cellar: :any_skip_relocation, ventura:        "e0703a1d8f37229a0cc595c408a1499a1725a7a40c5f4d39fa7a42f9099d6fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "073f9a884c9f87445e5b48bae849459d43266771da6f65e8797325ac6ad7ec8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c520543f642315dbbb51ceda76500f3d85fdc574b7d1874931e36e2c0e234507"
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