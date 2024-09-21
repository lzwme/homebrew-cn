class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.22.tar.gz"
  sha256 "20a839ac52f0416e3daba01809dd61e959e1bbc7b8e07aa0ce3aca0bb5570ce1"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afaeadedb62d6d5dcdd8437842c6135b00bbe7e43e71c5b95fcb343ab2a8447c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afaeadedb62d6d5dcdd8437842c6135b00bbe7e43e71c5b95fcb343ab2a8447c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afaeadedb62d6d5dcdd8437842c6135b00bbe7e43e71c5b95fcb343ab2a8447c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea7e5698735fd0ae4ab1a89407d44b0d1916072b66614adc755cb2fc5e015b5e"
    sha256 cellar: :any_skip_relocation, ventura:       "ea7e5698735fd0ae4ab1a89407d44b0d1916072b66614adc755cb2fc5e015b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe72ed8096773e53c97908b80cb8f24b2625db03a4d54ac33c23e95045bcb795"
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