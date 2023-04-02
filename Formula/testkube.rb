class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.10.30.tar.gz"
  sha256 "f0e58d16e40acf2e1829a5cf4689aedcf8a390fbca0deec5256314400f6ecb5d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f67098fe073a7ba2545ee9cc043d268025c25e57f9e911759873736e44bbc10a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f67098fe073a7ba2545ee9cc043d268025c25e57f9e911759873736e44bbc10a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f67098fe073a7ba2545ee9cc043d268025c25e57f9e911759873736e44bbc10a"
    sha256 cellar: :any_skip_relocation, ventura:        "bc8626c6c70ab08e43d53a5eeae871512c46c667a6da00cad633804d10490ac0"
    sha256 cellar: :any_skip_relocation, monterey:       "bc8626c6c70ab08e43d53a5eeae871512c46c667a6da00cad633804d10490ac0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc8626c6c70ab08e43d53a5eeae871512c46c667a6da00cad633804d10490ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e52ee9059e023b636c866f57cea61da6c1a33a04e92c5dc95dadba4703040073"
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