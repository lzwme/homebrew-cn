class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.65.tar.gz"
  sha256 "6db7490081219c0819e7ed630ca97bfcb27560624ad276e31d309673e574a871"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "608c5a8d315b9e91128a79718b561c917fb256709dd860d0cd94050b54f5e7cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "608c5a8d315b9e91128a79718b561c917fb256709dd860d0cd94050b54f5e7cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "608c5a8d315b9e91128a79718b561c917fb256709dd860d0cd94050b54f5e7cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ba7795d162e11217d17c7aa15ebb67b66bbc6b431cf8e2a6f33cca20e486267"
    sha256 cellar: :any_skip_relocation, ventura:       "1ba7795d162e11217d17c7aa15ebb67b66bbc6b431cf8e2a6f33cca20e486267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679ec94b1479637f0d427353be128cd84c64dfaf54175d5f40cd34b633c81582"
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