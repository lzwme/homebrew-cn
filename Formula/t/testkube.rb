class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.58.tar.gz"
  sha256 "5fa81e58a426850eb4f4c928e51657986d556b264dda30afe8c13f7b79bac6ec"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c45a9ce6099b100514e40a1c744b7998e399e2d6ed897269b4634c7ce4a31072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45a9ce6099b100514e40a1c744b7998e399e2d6ed897269b4634c7ce4a31072"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c45a9ce6099b100514e40a1c744b7998e399e2d6ed897269b4634c7ce4a31072"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7c97a22838c7767afcce0a597df84b182ffef4493a02f6541771fce78730334"
    sha256 cellar: :any_skip_relocation, ventura:       "b7c97a22838c7767afcce0a597df84b182ffef4493a02f6541771fce78730334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a49809a5bbbbd1570d26b4e9c5f352d1b09eb562b8b27f31a7ae84902904e1"
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