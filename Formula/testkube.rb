class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.11.20.tar.gz"
  sha256 "d3010ab4804cfee3c79ac3ec03aa74009155cb713a880a0cbb13c40ed6df7242"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d615553281feb0e3eafafcdef31f35d34f1ff0539a4cc2b546172e9364767c58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d615553281feb0e3eafafcdef31f35d34f1ff0539a4cc2b546172e9364767c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d615553281feb0e3eafafcdef31f35d34f1ff0539a4cc2b546172e9364767c58"
    sha256 cellar: :any_skip_relocation, ventura:        "57f7475597c86c7a91f44b2692ece0f2adef86756b5141bdfae4ba564833e303"
    sha256 cellar: :any_skip_relocation, monterey:       "57f7475597c86c7a91f44b2692ece0f2adef86756b5141bdfae4ba564833e303"
    sha256 cellar: :any_skip_relocation, big_sur:        "57f7475597c86c7a91f44b2692ece0f2adef86756b5141bdfae4ba564833e303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264223b1649121b05176709fc45739527e3ca113b9d774ab844a723bc88bc3d4"
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