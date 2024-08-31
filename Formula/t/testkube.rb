class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.6.tar.gz"
  sha256 "40c5345fbca2d1528ef49ca2e58b13563a5cfe88b9529e133b544e90434e2f36"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aeaed38560b9dc1d61cc77cdf6ba01f7b0f500f04f45ad4bd34f6c866f4f070d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeaed38560b9dc1d61cc77cdf6ba01f7b0f500f04f45ad4bd34f6c866f4f070d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeaed38560b9dc1d61cc77cdf6ba01f7b0f500f04f45ad4bd34f6c866f4f070d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3261483aad63e399af464259028dd4ae4fc29fe0074fd54836beadc5211f79a"
    sha256 cellar: :any_skip_relocation, ventura:        "e3261483aad63e399af464259028dd4ae4fc29fe0074fd54836beadc5211f79a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3261483aad63e399af464259028dd4ae4fc29fe0074fd54836beadc5211f79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbbafa2f68d5136bb19f85541264cc4241f7ec4577f70f74e1ad943a9d8805e5"
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