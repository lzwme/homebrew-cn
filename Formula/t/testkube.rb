class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.5.4.tar.gz"
  sha256 "6e73770a74e5873ef4b350be2e9ded3da6f72cb1af18ac7a89f4c038e3d3af0e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4325030a2d7df409c6c5e20d7543a1f54f113a0d641c30e928067084340f331"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d48790189e0ad264fbd397ba9511084758c4e185ee4e6b035354cec162a9d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a0f49f4e5071bf8b5a61771ef273d4cd5fc93c745ec66d3df3175a425428b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc4a83f6806d4ea7e12a2841e205ea447be9376307fbf7ea0f3f620871c28e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23339aadc62bb54675e4896f4641e488183a2999b59d8ef309f340b37424ccdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e33f7a3e912b1ad67a31d85e7fb01f8cf0f7fa65132abd207ebecf437227a19"
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