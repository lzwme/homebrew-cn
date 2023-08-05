class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.13.12.tar.gz"
  sha256 "67176f4eb67140e2ca31a542a8284f3b20c555e176b8a194676104d228edeb1b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acffab07df56891e5b7b729862776acbd29199561cb2934c095d9c11ab0161d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acffab07df56891e5b7b729862776acbd29199561cb2934c095d9c11ab0161d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acffab07df56891e5b7b729862776acbd29199561cb2934c095d9c11ab0161d2"
    sha256 cellar: :any_skip_relocation, ventura:        "4692748631e93c48d0d51b89f837caf6401243378fbb907c7e73465cd010b9fd"
    sha256 cellar: :any_skip_relocation, monterey:       "4692748631e93c48d0d51b89f837caf6401243378fbb907c7e73465cd010b9fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4692748631e93c48d0d51b89f837caf6401243378fbb907c7e73465cd010b9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f42bc5716f0b079b27d36f3d53caa0f069263ae65811724ba6e84f98ae6fadb"
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