class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.130.tar.gz"
  sha256 "25f70efee312cf089b6ea20352ad68a25880ccc994ec900c6eca527b6bad7047"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c9c1ffc664a0c8c7db1061fc4d8f35c1a90cf6ed03f33a0c5245164295e1a68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c9c1ffc664a0c8c7db1061fc4d8f35c1a90cf6ed03f33a0c5245164295e1a68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c9c1ffc664a0c8c7db1061fc4d8f35c1a90cf6ed03f33a0c5245164295e1a68"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bb30ff50de954bea7459b9993a772d45e3e9a5db8097972b2cba0114d9c1173"
    sha256 cellar: :any_skip_relocation, ventura:       "8bb30ff50de954bea7459b9993a772d45e3e9a5db8097972b2cba0114d9c1173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "030938e539f0380e1c28b010fa14e975e67edf9b65f2cbf6063fa376e21d5d3f"
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