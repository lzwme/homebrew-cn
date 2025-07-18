class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.163.tar.gz"
  sha256 "f2bba75a83b478a34089867db09c385b820e8baa08b6ed01f2d55f7f4b50d0fc"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c31bf09f6bcd7ff80588bb11762a3a8b5505c956aa68bf9f5e3e208b93a821f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c31bf09f6bcd7ff80588bb11762a3a8b5505c956aa68bf9f5e3e208b93a821f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c31bf09f6bcd7ff80588bb11762a3a8b5505c956aa68bf9f5e3e208b93a821f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7940835528762a6e65529680459e8c1cf6c43867a34b1f843170b3055a2c1067"
    sha256 cellar: :any_skip_relocation, ventura:       "7940835528762a6e65529680459e8c1cf6c43867a34b1f843170b3055a2c1067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa7c1a1831d75237047f6f93e96d601c91bc8e4aec6d1d20e45054b857c5cae"
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