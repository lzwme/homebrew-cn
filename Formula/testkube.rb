class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.13.7.tar.gz"
  sha256 "79f1894ad3fc06d03edb67df574da6f68e2f0d61b256c6e63a468cb6bc7c52d5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f438a70a01386df28b7d927950225e57afbf8583ef0348454fae0f737576fe0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f438a70a01386df28b7d927950225e57afbf8583ef0348454fae0f737576fe0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f438a70a01386df28b7d927950225e57afbf8583ef0348454fae0f737576fe0e"
    sha256 cellar: :any_skip_relocation, ventura:        "129ec2de1a3bccd56732ca769672fa72e9572b96ca08ea36c9d01872df62a46a"
    sha256 cellar: :any_skip_relocation, monterey:       "129ec2de1a3bccd56732ca769672fa72e9572b96ca08ea36c9d01872df62a46a"
    sha256 cellar: :any_skip_relocation, big_sur:        "129ec2de1a3bccd56732ca769672fa72e9572b96ca08ea36c9d01872df62a46a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ef8b2ecd676a415ab954963aa99ef1568e566d97e2eb62f1ff1f4157fad76f"
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