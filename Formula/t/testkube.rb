class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.53.tar.gz"
  sha256 "86c783f2c056ab3410be2b484e3bfc89df4969c5d468d3e83495d63c82853308"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c02ae638405783f4266260ff578200270fbcf595a1a53bd5f72c116f5dc3b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c02ae638405783f4266260ff578200270fbcf595a1a53bd5f72c116f5dc3b9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c02ae638405783f4266260ff578200270fbcf595a1a53bd5f72c116f5dc3b9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf4b5291c2707e0595edbb8f627cac19303e9c036c09cb847a13c5aaa7e454d5"
    sha256 cellar: :any_skip_relocation, ventura:       "bf4b5291c2707e0595edbb8f627cac19303e9c036c09cb847a13c5aaa7e454d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c945fe3412f89f72d61a46515a92ab784a6cc8bbd4a30ee13966017ea7c4efb5"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

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