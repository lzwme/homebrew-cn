class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.21.tar.gz"
  sha256 "61f4d08dc4bf173c01130fa6c03f3d99e3f953206a1e63095fe49accf24e3b49"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68334443b50e67adbb6cbdbf3b938b0277169d95fe4c08d5ac23cbb3f89af3ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68334443b50e67adbb6cbdbf3b938b0277169d95fe4c08d5ac23cbb3f89af3ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68334443b50e67adbb6cbdbf3b938b0277169d95fe4c08d5ac23cbb3f89af3ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "085c2ce1532fa72de22b8f3e4a0bf8fdcb11a2e12ce85a82fd2427e69a568696"
    sha256 cellar: :any_skip_relocation, ventura:       "085c2ce1532fa72de22b8f3e4a0bf8fdcb11a2e12ce85a82fd2427e69a568696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda7986108207b87f5cb5bdf6cb2c5a2476638ad0974a69cc1102c2643f04cca"
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