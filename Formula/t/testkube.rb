class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.15.tar.gz"
  sha256 "12f5ee40fa6a59807cfcc942e3d139260b9c86802269b03aed99e18cb5f60449"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2766a4824a6fdfcc5d29bbc5226d042c5def743a2639534498968bdb0a21ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2766a4824a6fdfcc5d29bbc5226d042c5def743a2639534498968bdb0a21ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2766a4824a6fdfcc5d29bbc5226d042c5def743a2639534498968bdb0a21ba5"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd4f8cb8b4f7b3f0c6c83f188b4bb1ab14a9922f939ea58c71e60e4e15f06eb4"
    sha256 cellar: :any_skip_relocation, ventura:        "bd4f8cb8b4f7b3f0c6c83f188b4bb1ab14a9922f939ea58c71e60e4e15f06eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "bd4f8cb8b4f7b3f0c6c83f188b4bb1ab14a9922f939ea58c71e60e4e15f06eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c38b08900313f07f2e303a702c047fea735c369304ce0071dc5cba381b819f8"
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