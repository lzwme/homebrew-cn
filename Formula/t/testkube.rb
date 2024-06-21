class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.64.tar.gz"
  sha256 "0512b423d96faf3054a002e7a3e438e5969050c27bb49667a099dc5cfebf47be"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9abbf41c4c4472e4e8e1690503c08e9c64231173241a07746afaddfc87f4b4f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9856d2871ef7092cf7176a82205d9672842cb8e132a1c456b5172b863e7271e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6deefa5780bf92dad5f2e74a21ca8f0da002ece2606c5b855922e7f87f24356b"
    sha256 cellar: :any_skip_relocation, sonoma:         "873ee950f94ffe2cf8fee269871bc9a8640b7b3cfeb0840797a6880c708e1151"
    sha256 cellar: :any_skip_relocation, ventura:        "8fd3e595a62824f850886e8f20010c5442e781aa09d426cc10492b3a20077866"
    sha256 cellar: :any_skip_relocation, monterey:       "4e07054b94bd553e522587bb68ea8a3c2d917c9b01cb0c89b70f0877d13409f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58badd81412531d3b08ed0d58746e793322f25beeabf18aab24af0e9ab891c43"
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