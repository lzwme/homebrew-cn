class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.6.0.tar.gz"
  sha256 "fc020ee6cc8bb4b420e5cf0882eba9999c93330b1139db56e9389d9527b0ad01"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de4be9c4a677d4a73946554a3980440c50e406b4317efe13535b49ac3192ba3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659d6516606f0d989cd5c76d41af5e52bd8647d9c3c11341417d46ff8772c4ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f80c38ca1ed7f86cb0930fcfae3d1655ddd40ebf4a2a023a353ceadfe3eeae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d1c3c6184162dc93cd472146bd243e448a1cc01682f042ad060496a3b2509b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e97dd87354897a90e2d7769649bb4a78523a5f8246a6d4123afcb56079500600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66a7d67852ea42c509ebb77b09cf77db5ded9a1e2c2ce787133a4fbdd3bf6709"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end