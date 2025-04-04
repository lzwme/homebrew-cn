class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.134.tar.gz"
  sha256 "0192d124747ef40d5b4d4201d129f0276e3910c192a6a2b3c6f125d01ce80d37"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344c3545bf301223047bac3abccedd5d1619c9e8aca4fe823dec771cf152c065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344c3545bf301223047bac3abccedd5d1619c9e8aca4fe823dec771cf152c065"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "344c3545bf301223047bac3abccedd5d1619c9e8aca4fe823dec771cf152c065"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f8890ad42d3cade57e17597a0bf66ad571a784901e3def66cb9b5f46873e112"
    sha256 cellar: :any_skip_relocation, ventura:       "3f8890ad42d3cade57e17597a0bf66ad571a784901e3def66cb9b5f46873e112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2611ead21595551f124fc4cd2632618642eae26e337fcb61db0c70713d26e10c"
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