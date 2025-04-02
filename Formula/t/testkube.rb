class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.132.tar.gz"
  sha256 "996ffd597a7aa1e4e90e13c00c23d1bc2687b36df4cb6d14e6dac3fc11c8a530"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2c2b49a451eb346481813d88a316a039933a75078cad183b6f6838dede87b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a2c2b49a451eb346481813d88a316a039933a75078cad183b6f6838dede87b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a2c2b49a451eb346481813d88a316a039933a75078cad183b6f6838dede87b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "32bb884914cb8c8f43ead62a0463334b92f9dec67d195489963f879d03e9d100"
    sha256 cellar: :any_skip_relocation, ventura:       "32bb884914cb8c8f43ead62a0463334b92f9dec67d195489963f879d03e9d100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb073bce055261d261e6b856cb48e0f37a37afb69a8cdd65c7b8306271f88ef0"
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