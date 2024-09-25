class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.23.tar.gz"
  sha256 "aaed40871a001bcdf40eb86cf145ecc342a0d3afe5a951779308b1d022caae63"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336ed4756cb5931f63d826690a1517e33dc5908387dd3040be8ecee50b554cb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "336ed4756cb5931f63d826690a1517e33dc5908387dd3040be8ecee50b554cb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "336ed4756cb5931f63d826690a1517e33dc5908387dd3040be8ecee50b554cb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f555049f70c09370a2321655b2bb7de37bb40b7dc82cbb6a2502a474053b33f"
    sha256 cellar: :any_skip_relocation, ventura:       "7f555049f70c09370a2321655b2bb7de37bb40b7dc82cbb6a2502a474053b33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c67f99167c5b6b3612bd29a796642cc3bf23c5e9c91089f48a0e94edb8a8b21"
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