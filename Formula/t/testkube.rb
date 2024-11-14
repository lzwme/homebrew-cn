class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.62.tar.gz"
  sha256 "413fdce2338612b6c18c5819f1d16a4c2732f117f93a2bccd6721335c540c6a9"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b1f146526078145768e0159f49feb4ad649b6f3c5600402e4f8d3ad512d4f0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b1f146526078145768e0159f49feb4ad649b6f3c5600402e4f8d3ad512d4f0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b1f146526078145768e0159f49feb4ad649b6f3c5600402e4f8d3ad512d4f0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "81acfd90e471d9d9e7e1caadb4156e774d11e8c03c787e0d05cc450edf2ca7a0"
    sha256 cellar: :any_skip_relocation, ventura:       "81acfd90e471d9d9e7e1caadb4156e774d11e8c03c787e0d05cc450edf2ca7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a18212522bd7972975073bfd94aa59de1d424f2e6544febe37b00e892e7a675f"
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