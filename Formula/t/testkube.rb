class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.2.tar.gz"
  sha256 "3ff4af7418e8cd4688c6333a48b6e771dcc7d28491c90668e645b2dd0148dc1d"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afdb72092013e1479bbaa091d30842abec8218d7bff9285e21f5f89df67a7ecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afdb72092013e1479bbaa091d30842abec8218d7bff9285e21f5f89df67a7ecd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afdb72092013e1479bbaa091d30842abec8218d7bff9285e21f5f89df67a7ecd"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a48280b23729169c5052280b16e57d888c52340b5a2bdf31109f1b8413e2e86"
    sha256 cellar: :any_skip_relocation, ventura:        "1a48280b23729169c5052280b16e57d888c52340b5a2bdf31109f1b8413e2e86"
    sha256 cellar: :any_skip_relocation, monterey:       "1a48280b23729169c5052280b16e57d888c52340b5a2bdf31109f1b8413e2e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fef36ca837802f80bf2f5abdbd62a506e24554414f496d3bbbcf142c9c0b9cf6"
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