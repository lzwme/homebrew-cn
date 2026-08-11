class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.12.1.tar.gz"
  sha256 "792f87fdb55cba761b85a1ea2897a35a36030e87b5117ed8a92ca973cf317bc7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d6282588930c4aea5aa8bf982325b9847bcf5b74a81bca204f56bf5a8d027bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc2cc373da64fab889c62c2718d5cf7ad54a1233c35d5f68f7fedb780e903683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c132ee98f0e6e4dce8f39b3874062ffb2a9243adc850041a09c2beb193eb6888"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8552341bc1bd9ea9179b59029db3a498e57ba12af0dcd2c4834050068757d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccd9c377a8462248d2504028379c39c74ed53cd18468e17aaf11e4496cfab020"
    sha256 cellar: :any,                 x86_64_linux:  "0bead2c2640550cd404fae3ac6834a589dfdffc8f301195e20d3248e3cf00b67"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-X main.version=#{version} -X main.builtBy=#{tap.user}"

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