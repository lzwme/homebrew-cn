class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "d49d2dcb0af3f9d62c1023b6b4e39057a09f9a39624d436e021a8dc0aa45c0ad"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f525a9e0f7475c2f517a637199d8e27171dfa1370e9801cdd699d6ee35dfcb9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f525a9e0f7475c2f517a637199d8e27171dfa1370e9801cdd699d6ee35dfcb9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f525a9e0f7475c2f517a637199d8e27171dfa1370e9801cdd699d6ee35dfcb9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a07d7a9f0d12bb47860061d2c1ed21315f7c659db158095c5c3b3522efca059f"
    sha256 cellar: :any_skip_relocation, ventura:       "a07d7a9f0d12bb47860061d2c1ed21315f7c659db158095c5c3b3522efca059f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01acd934fcff37c0d9ee99e3c95f367b5be890d5cbe9c9fcb44f67e77f2a78fc"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
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