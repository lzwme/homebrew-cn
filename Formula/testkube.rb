class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.13.11.tar.gz"
  sha256 "66db7ea8a778f4efd1d18ac65ba6355a10dd3e4074e21498dd974a7c3e1e85f9"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa2e5e90ef3debcd01e8b46de377d3de0c20ae1ae0b101ef66f56e0535584d58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa2e5e90ef3debcd01e8b46de377d3de0c20ae1ae0b101ef66f56e0535584d58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa2e5e90ef3debcd01e8b46de377d3de0c20ae1ae0b101ef66f56e0535584d58"
    sha256 cellar: :any_skip_relocation, ventura:        "27b4292a8529c59a3a24d8c392479c563e0bfecccb08811f8b24c0f3901129b5"
    sha256 cellar: :any_skip_relocation, monterey:       "27b4292a8529c59a3a24d8c392479c563e0bfecccb08811f8b24c0f3901129b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "27b4292a8529c59a3a24d8c392479c563e0bfecccb08811f8b24c0f3901129b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a09e11795c10963eff6d81f190f63948c69fac84cd450c3d14db73797fcdb700"
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