class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.158.tar.gz"
  sha256 "ea2a512116d286f8556d10e9d3f6c1e39861408804057cd56c9e35b27b4184dc"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebe9b9d78c74f6af5ac0008af033a3ef4a221f5517b53d7c4290765f45741224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebe9b9d78c74f6af5ac0008af033a3ef4a221f5517b53d7c4290765f45741224"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebe9b9d78c74f6af5ac0008af033a3ef4a221f5517b53d7c4290765f45741224"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9cb27ab0ec187d1f2bc130ef6f2e94f9b2c1753faf8bc478c93c7123a743334"
    sha256 cellar: :any_skip_relocation, ventura:       "f9cb27ab0ec187d1f2bc130ef6f2e94f9b2c1753faf8bc478c93c7123a743334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "353b626bfe09d7a24acd7f043c2efda63cd27a53898953bdb75e6427fcbe72d2"
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