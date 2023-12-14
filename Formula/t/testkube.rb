class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.14.tar.gz"
  sha256 "229857037c37b219a0dbdb7b9723d5241d78f68f4187bfde4c9a55c38fb9c89c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a612306a95ab08f896e9421d8782750fa34789827869e9205f75db31adcb58ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39be8752f78876cce7fcb30cd73f70a05def68395dc0c1aa9f8a8299c9b73b44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77e9583d98687b3a44f2a3511ab81738297296807ea947c5ac0384a7936a5d28"
    sha256 cellar: :any_skip_relocation, sonoma:         "31d434810ed1847a8dc7567187c4abcc793dc317355e613c3637c643eb8b74c6"
    sha256 cellar: :any_skip_relocation, ventura:        "479f139b00336a032ffcfe8dc3e53a08903490183ad095cefc7263d70afd2797"
    sha256 cellar: :any_skip_relocation, monterey:       "8e1b2779ab41224b78cb740fa54fc8d44ab8533f258f7ead7871c71fffed3683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7de1e7b3be4ea0878d4661cc3f0a4cb66f455b2959ebb1b54cdc163cf075a49f"
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