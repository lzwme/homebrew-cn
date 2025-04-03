class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.133.tar.gz"
  sha256 "3c893386cdbafb9707874931f9589d1837f5876cf18d5bef541deaa9d6ba3873"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c387f69791f21ee5bacf83e9524dd4654d573f553de094a2929154531aef69a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c387f69791f21ee5bacf83e9524dd4654d573f553de094a2929154531aef69a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c387f69791f21ee5bacf83e9524dd4654d573f553de094a2929154531aef69a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "17a10e452c5b536abf5b66f29c93b55bcd7b0532c46b152d75ae39509ea1b9d6"
    sha256 cellar: :any_skip_relocation, ventura:       "17a10e452c5b536abf5b66f29c93b55bcd7b0532c46b152d75ae39509ea1b9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ebf46393515d8a7a35b9989dcaf5ef2256c447456a33f9b8b5aa764e4409b18"
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