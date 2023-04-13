class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.10.45.tar.gz"
  sha256 "af11ad61b91de726ef694f989f7a92f228dbf3369298e6ca10116458e44ab388"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2196afee3c6b04d9dd776a0b6f54808fa22ca60c8d1dbe1b36163a36f50d2ad3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2196afee3c6b04d9dd776a0b6f54808fa22ca60c8d1dbe1b36163a36f50d2ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4ea305ea1e33eb2922caf20ef80c5654323bb093638ca3080e176189dde3ece"
    sha256 cellar: :any_skip_relocation, ventura:        "16f09cddeb62d71828d02d8c84eca232e33304a087da0251d553d87a348e3b98"
    sha256 cellar: :any_skip_relocation, monterey:       "16f09cddeb62d71828d02d8c84eca232e33304a087da0251d553d87a348e3b98"
    sha256 cellar: :any_skip_relocation, big_sur:        "16f09cddeb62d71828d02d8c84eca232e33304a087da0251d553d87a348e3b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa0372265e1dd703428be2fb331c206c9b5e61f9fc1a0063728968996b54fa3e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
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