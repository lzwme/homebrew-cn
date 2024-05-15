class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.31.tar.gz"
  sha256 "029c61cd2ea0cb5adfc12461e12f151212b294b138f37d9fab495bc08df6ee10"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d82277871f74bbe3bfa7735c0d2b36d91b4cac2b858f5aac76eebc9f2d6c20d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "059e2caf611aaf333a947885a4e4eba67dda91bb16497998a6c1a746cb43d842"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfaf299e947aceb4733a96b6af8dd0b2ac1ecb00561c434ee518b7d26d26ec0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6609a5a5bce97e744cc531f2f159b84c61834ab33d230b3e345e8f29b798aab0"
    sha256 cellar: :any_skip_relocation, ventura:        "f0d3c8785bb9e038575b029ff0b06ba3be500460b7a48da1582f387965799f04"
    sha256 cellar: :any_skip_relocation, monterey:       "843c84441d8f19d4372232813a1e772776a410b0c23adf029c5a3135754f63c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f10b017d45c2e0d78b90bd5506969715c304ccd156a6a6567953e06bf2ffff"
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