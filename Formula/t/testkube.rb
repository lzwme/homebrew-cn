class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.33.tar.gz"
  sha256 "79ed8eb05df185d47351e8c9953b60c9116d12f2f530ce151e74b1df30d75c2e"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55a0b65bfeda400c8c053168c4d5db6cb7da258a0e84b248b964763db5be3513"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55a0b65bfeda400c8c053168c4d5db6cb7da258a0e84b248b964763db5be3513"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55a0b65bfeda400c8c053168c4d5db6cb7da258a0e84b248b964763db5be3513"
    sha256 cellar: :any_skip_relocation, sonoma:        "d760ee50f3cfd7460e305db8737d7daa93eb8c9c8925b5a840789d77c2cc1ef4"
    sha256 cellar: :any_skip_relocation, ventura:       "d760ee50f3cfd7460e305db8737d7daa93eb8c9c8925b5a840789d77c2cc1ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa6ba9bb2b3556bdcd7dfcf26674c44b730ea08437d21c1330b9c705d49de7c"
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