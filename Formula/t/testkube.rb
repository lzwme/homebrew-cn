class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.156.tar.gz"
  sha256 "d919149ecc886dd25d1f4fc604daad6d8281095e8b4f21b4d64785e56cccca1c"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b7249b6bf66aeea03e05b78d7d696a1414910b9944ac64ecdef1195ecd3a8cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b7249b6bf66aeea03e05b78d7d696a1414910b9944ac64ecdef1195ecd3a8cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b7249b6bf66aeea03e05b78d7d696a1414910b9944ac64ecdef1195ecd3a8cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1207517e191ffac779feaddc2bcc8415926d4f6432f095bb48a72a7c36da2aeb"
    sha256 cellar: :any_skip_relocation, ventura:       "1207517e191ffac779feaddc2bcc8415926d4f6432f095bb48a72a7c36da2aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c498adb9c931f46245048a8a82ee236a875b810dfe599482a6a9e249ee6838"
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