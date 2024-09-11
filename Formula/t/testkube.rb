class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.18.tar.gz"
  sha256 "9eae5c23f80ce933eb219af8920fde6cb6e9bfca10bd2395bb41d4591611d51f"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "96016646a0bd3ccfb6dd494b708cdb6d6d4c5ec1304204ae7608f2ef2d0f3bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96016646a0bd3ccfb6dd494b708cdb6d6d4c5ec1304204ae7608f2ef2d0f3bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96016646a0bd3ccfb6dd494b708cdb6d6d4c5ec1304204ae7608f2ef2d0f3bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96016646a0bd3ccfb6dd494b708cdb6d6d4c5ec1304204ae7608f2ef2d0f3bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d05b4631c0a84bbd01c8d14249a263d2763c81c1065df6406ca1c35317acd71e"
    sha256 cellar: :any_skip_relocation, ventura:        "d05b4631c0a84bbd01c8d14249a263d2763c81c1065df6406ca1c35317acd71e"
    sha256 cellar: :any_skip_relocation, monterey:       "d05b4631c0a84bbd01c8d14249a263d2763c81c1065df6406ca1c35317acd71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3148f2dcce4a97e0c9393298fdeed0fc5d0d2a48a25493a7ff088b5619b70a4b"
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