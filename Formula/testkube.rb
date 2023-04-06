class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.10.35.tar.gz"
  sha256 "032e42da19fedce431ec2a5566a889d996a8e1ff73631547c4ed845fc8c4879d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b6db9ed7f17cb1e4e93d82d8d9969f0e360c9d58ebc0d782612c159a0a767d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b6db9ed7f17cb1e4e93d82d8d9969f0e360c9d58ebc0d782612c159a0a767d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dab390fb26c8bba06a2e04445f68f86be6ffa78015bdd84b620788453a07908"
    sha256 cellar: :any_skip_relocation, ventura:        "f8802f4145eb96c36206ebc230772c5887b1df2bc768569cfa6256311d5676d0"
    sha256 cellar: :any_skip_relocation, monterey:       "bd85416c78a9549d60ab9c911a79884c20b86c3bd781b5907872c2ae0986dfe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8802f4145eb96c36206ebc230772c5887b1df2bc768569cfa6256311d5676d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2b38683687e49cc1dec87ba22e8b88b2206823702cbb7132a0f6ed11408fde"
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