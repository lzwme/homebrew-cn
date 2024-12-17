class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.77.tar.gz"
  sha256 "5b62d3a84300c60571b731a0a2e7b30a4b32fa56e6b076ecfdd23223e7d5e89a"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6e40dd942694bb126e835ba462369ddb66cf2fbabfff166a8412350e62b2e2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e40dd942694bb126e835ba462369ddb66cf2fbabfff166a8412350e62b2e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6e40dd942694bb126e835ba462369ddb66cf2fbabfff166a8412350e62b2e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "54633a31554f4585825dbbf637c5cd70b919cd8172a0a1386191a9cac4792ce0"
    sha256 cellar: :any_skip_relocation, ventura:       "54633a31554f4585825dbbf637c5cd70b919cd8172a0a1386191a9cac4792ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31abfa706bd6187d87e4ff0093e10f530510045a51a62ce61c88100495d6efd"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion", base_name: "kubectl-testkube")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end