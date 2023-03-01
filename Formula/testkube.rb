class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.9.15.tar.gz"
  sha256 "d7b3177c7360a7f2513fa2eda3ab8c1abc73fcec2a09d31ae43e54805a8b714c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95c8aa11915d022e7d6f70af997571fc0794b00bc71666db0a32aa8a43e48962"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95c8aa11915d022e7d6f70af997571fc0794b00bc71666db0a32aa8a43e48962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95c8aa11915d022e7d6f70af997571fc0794b00bc71666db0a32aa8a43e48962"
    sha256 cellar: :any_skip_relocation, ventura:        "81a75056d831244ac8e208fb23bd447b75bab17be08953378ca1a92c3cd467ac"
    sha256 cellar: :any_skip_relocation, monterey:       "81a75056d831244ac8e208fb23bd447b75bab17be08953378ca1a92c3cd467ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "81a75056d831244ac8e208fb23bd447b75bab17be08953378ca1a92c3cd467ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ae2533ea3bdc0ae0f1fefbbb0f5d5121a4606c85baf38d907fbb1c0f60b907"
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
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end