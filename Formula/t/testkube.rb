class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.0.tar.gz"
  sha256 "153c318bf6207651381dfdcb46d5a143976c1a2c0e15bc9609a8928407914205"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e6baef43fe3cfb11d5b821c5e3ba4b76c880d5b5e82b8d677d24535ca3190b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ed95258efd5de2b529551461dfdd58b273a35d4df9347c5e37025353bfb3a55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "103b57870d55c22356ca35d1e676816acf8b94ada00ed69ac5552d79134cac67"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9d6a5f58f8bb2a89a9ccdf77876bf754c685df5b5ee4b3369ede1935ff90d56"
    sha256 cellar: :any_skip_relocation, ventura:        "1b56c7b9f976c1ffffd16f5d6feba7d1dc6d6f6af22897c0e109cea82e9ea28e"
    sha256 cellar: :any_skip_relocation, monterey:       "7861556eb79ab468f6360dbd63f11817cecab07d0eebdff0b5127e1e90e99574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f143094ea37037f0480d27e4258b6aba077bfde5c01896481ed1ab65453aaed7"
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