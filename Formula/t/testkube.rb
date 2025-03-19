class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.118.tar.gz"
  sha256 "60f68b43c59e2f2df440852f5b31f2b95e279962ca763b26901ced37087c715b"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a22b06db9b5cfa5e7190dbce65675c4a929cb8863b0adedd49444787102d49a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a22b06db9b5cfa5e7190dbce65675c4a929cb8863b0adedd49444787102d49a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a22b06db9b5cfa5e7190dbce65675c4a929cb8863b0adedd49444787102d49a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0323b94e2389e9ec6f76d30031e243289516cded47c7ae61c7f49e4e1b6b5de4"
    sha256 cellar: :any_skip_relocation, ventura:       "0323b94e2389e9ec6f76d30031e243289516cded47c7ae61c7f49e4e1b6b5de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b47008a5af88f6f9bc60867be034119e97ad9dcefcbd276052833f9983a1437"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
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