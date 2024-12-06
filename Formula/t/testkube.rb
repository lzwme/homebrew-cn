class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.72.tar.gz"
  sha256 "b6ddefc0a43dbb5f59c7fbd71a44ff7cefe9fb35069660102c539006e0de36ee"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e175f244fce41bb5a6fbff887b3787807147a16bbd4519d562fb04cbfffec1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e175f244fce41bb5a6fbff887b3787807147a16bbd4519d562fb04cbfffec1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e175f244fce41bb5a6fbff887b3787807147a16bbd4519d562fb04cbfffec1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b066c7dd83daf3dd76ea6392e0184595fcdcc2df69845a935517cdf3fcc6d4c9"
    sha256 cellar: :any_skip_relocation, ventura:       "b066c7dd83daf3dd76ea6392e0184595fcdcc2df69845a935517cdf3fcc6d4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d850de906c2669e7bdf0048dc34e51b7f2fa5bba9dcd98e6b8cb84b6b1018156"
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