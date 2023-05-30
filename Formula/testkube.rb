class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.11.25.tar.gz"
  sha256 "d873af9bf1e3016719a3aa6e4d69ad950ec1c7134d476a6cdca1c4a42def9c45"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b2a43f9e36f1f13ba1cee2d0a4d1d8d5183b5d4aa64f144e0ad10b10bea4566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b2a43f9e36f1f13ba1cee2d0a4d1d8d5183b5d4aa64f144e0ad10b10bea4566"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b2a43f9e36f1f13ba1cee2d0a4d1d8d5183b5d4aa64f144e0ad10b10bea4566"
    sha256 cellar: :any_skip_relocation, ventura:        "24c82e451ffec4b5e7c223cf845cf54544fbce3fe99447496f2266648a8264e2"
    sha256 cellar: :any_skip_relocation, monterey:       "24c82e451ffec4b5e7c223cf845cf54544fbce3fe99447496f2266648a8264e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "24c82e451ffec4b5e7c223cf845cf54544fbce3fe99447496f2266648a8264e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a5f6d4e770d71b6ad4318983c012935bd7f978755f1449932ed4d4d7f459f5"
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