class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.26.tar.gz"
  sha256 "973122cd16b037b0230c5a35e760def4b23dbd00be7b54a67c4bb1cc1223d341"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "603155d73d19b4406a9eb612e9b052e3860987a123e5c190ddbe99d2de8125b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603155d73d19b4406a9eb612e9b052e3860987a123e5c190ddbe99d2de8125b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "603155d73d19b4406a9eb612e9b052e3860987a123e5c190ddbe99d2de8125b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "271f0f9afe5bfa99037e64fa15ec34668921bb638d9d783388d0e93096835aad"
    sha256 cellar: :any_skip_relocation, ventura:       "271f0f9afe5bfa99037e64fa15ec34668921bb638d9d783388d0e93096835aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671e76b7c1aa5462239a5abc01d162aed9d7c51ff35679624f1e5d315ed46a87"
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