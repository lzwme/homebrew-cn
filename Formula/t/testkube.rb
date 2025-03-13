class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.113.tar.gz"
  sha256 "04c8f058446470a31f40750b5d6b5184caf8ab3e07fe079c3f7be9a0c256961b"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ac79aaab2fe7482b394646d0e4c1b0ce4ac1025361394278105a35b7fabcc7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac79aaab2fe7482b394646d0e4c1b0ce4ac1025361394278105a35b7fabcc7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ac79aaab2fe7482b394646d0e4c1b0ce4ac1025361394278105a35b7fabcc7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91039cb96b4e2eb4616da29a34458c67f14ee737af9a82c08a1b63284887641"
    sha256 cellar: :any_skip_relocation, ventura:       "f91039cb96b4e2eb4616da29a34458c67f14ee737af9a82c08a1b63284887641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd050880180399b2b30b2669b23635b0780c0eac98e6bfd35738b6f675a80620"
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