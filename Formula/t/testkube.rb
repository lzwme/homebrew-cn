class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.18.tar.gz"
  sha256 "4f2ea51dfec80a11d07903aef18b97432872f2aa77e9e29d9281ce31ac26fb40"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83b99a43c5dcca9163744e7b56b5469587619d37030368f860f5e759df29c70f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae0750b329fa35460bb420144111396dbab7249d8156e14752bcfa2f575b7914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7443317bd0c561a99c3b07be138995b2b80574598db73984fce929e35f590f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4276868deef8d3a274df59c85cfce8898d3cc1fbad61d33724bd74f71b16dbaf"
    sha256 cellar: :any_skip_relocation, ventura:        "43646e45491d02968d0f271d1bb5325a32e7bbeddc93af71dc4e47a6725bb571"
    sha256 cellar: :any_skip_relocation, monterey:       "fc00fe58e5de25d778419b70215a43010aacdcadff48d56a0077f907db7d7595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d1b60b60f1e84b44d500908b191e322414aca79b13957f99c099f2754a67ea2"
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

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end