class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.42.tar.gz"
  sha256 "2efca36e9137e753eecd8bc6cd7a6150134b0aff472f032be57cda73baa6d16e"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c669e4ac05781a7261d42335406fbcb889ce4636dea7e0e8c7482b47be0af8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c669e4ac05781a7261d42335406fbcb889ce4636dea7e0e8c7482b47be0af8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c669e4ac05781a7261d42335406fbcb889ce4636dea7e0e8c7482b47be0af8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "267dd6b8bdd8e3cc7b4f3d1915e46763e56579501f34267e2f132cf764cea4c1"
    sha256 cellar: :any_skip_relocation, ventura:       "267dd6b8bdd8e3cc7b4f3d1915e46763e56579501f34267e2f132cf764cea4c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "454ca43fc5be31c24f7cb3dc15bf081bd9dd9d275c6dc0a1e8a06db50e991817"
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