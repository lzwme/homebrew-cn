class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.60.tar.gz"
  sha256 "839cae0613052215aff0d508193fb67eb4a645d0894c2b849f6104749b474855"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8470cc63375caf6fa7e7e6ed889bb1d634ebedda06036189ca44725f88253fb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8470cc63375caf6fa7e7e6ed889bb1d634ebedda06036189ca44725f88253fb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8470cc63375caf6fa7e7e6ed889bb1d634ebedda06036189ca44725f88253fb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb46c3ffe145200532944599be762dd9fb8ef9cc20d1a050a9d06f571f6dcdc"
    sha256 cellar: :any_skip_relocation, ventura:       "7eb46c3ffe145200532944599be762dd9fb8ef9cc20d1a050a9d06f571f6dcdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4c138ee104adffc0f123a4dd3d636b0272061dfa7aef9b1572ce63df5b56b1"
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