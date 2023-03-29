class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.10.20.tar.gz"
  sha256 "c2b6ac8ba1359586236a524c4fc52d0b993b67a722f5be1a6b240868ea11cdd9"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79e7d6715732ff6f15f84f7dbe4a5981955adfb47981df3660f0988b4ca4e2e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4ae41496f70f0fcfce0e9a1dc5397a5681889a5ac1c4abf9dd5200b61b4e9c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4ae41496f70f0fcfce0e9a1dc5397a5681889a5ac1c4abf9dd5200b61b4e9c2"
    sha256 cellar: :any_skip_relocation, ventura:        "8c0a7bfe30fa13972212c997b23d1b31a8d4650c6e019dd82528e0f87597d8c4"
    sha256 cellar: :any_skip_relocation, monterey:       "8c0a7bfe30fa13972212c997b23d1b31a8d4650c6e019dd82528e0f87597d8c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c0a7bfe30fa13972212c997b23d1b31a8d4650c6e019dd82528e0f87597d8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9702de6bdd3e4c27e8fd42010ac66a3292b4dbb257d4e26104e105e095d0305"
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