class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.155.tar.gz"
  sha256 "b9b80e3bbda200fa1033d29f98e6aa837c6a6ebcfd23ffbdd7fb51c2901988e4"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e19a68467bf90c0b9b994bfba8a20aa0e56c4f65e36ac3de069dcd08ec1e2f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e19a68467bf90c0b9b994bfba8a20aa0e56c4f65e36ac3de069dcd08ec1e2f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e19a68467bf90c0b9b994bfba8a20aa0e56c4f65e36ac3de069dcd08ec1e2f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cca640d348419bdb0385d20792b8a16e6234175531e54e2d640e218c467f0bf"
    sha256 cellar: :any_skip_relocation, ventura:       "0cca640d348419bdb0385d20792b8a16e6234175531e54e2d640e218c467f0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4edcce96c70bb403eeb78d91d04b8eaee65ebfa321c9235f920b867eee249ff1"
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