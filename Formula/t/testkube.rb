class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.7.0.tar.gz"
  sha256 "509c365ae9dde14e404ff15d697594f878b53dc4b814bcee45c18604894ecd99"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4709ffc30d27be00c2c300d48b8e9f883350a5bf620d9d5cbf6263f21e3d53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d473bda75ff2b8085c6727bbadf5a48cef613779df3b1881e0cf58cc9196e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9cb04c1c9a798618a0f8858c88e4f3f185f69e7398d2176302551ba420af928"
    sha256 cellar: :any_skip_relocation, sonoma:        "745671c0a96026d0369c92bfe1100afb37da5cb511336f1ad94e4a7337065a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "057997890065e676e3c3e45950d0b877f028edd78573da651fbf5bcf9f41171e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "241bea10e0b46a2217ebac9b6c43fd0afbc3b1906ca8a1008cebcb70bfe376af"
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