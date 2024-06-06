class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.54.tar.gz"
  sha256 "dd61050946d0b57e959f4bb5bee4cba016773ecc96b55dcdcf0e564c505c8fe4"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67dfa37bb49b548d6732e5debb8ab79c199e7badf274f9dded27afa6b5a52a81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6556111b023ff0567e1c2f536cd4de7ef6808c70dc82e714ef73890ca958545b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ad2762405f9511d80a0759e455b340fc1cede6a2ea3a6b9de7155adb8ebdb6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea8af922bf604247d205dc815d3b970e3364ecb32ac9d8e5f385bb231e34a1fd"
    sha256 cellar: :any_skip_relocation, ventura:        "b72755134f1441d57464cd484397a24fad52b781e6e966950803d960b8c8295e"
    sha256 cellar: :any_skip_relocation, monterey:       "79a81c28e46c8da93a084fd3907645e3853e2c431a6303f575f7946086f44d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a310fc8bdcb907eeb21158ac7e54b62c5e78ad4b1bccb21fedd7715e63042b"
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