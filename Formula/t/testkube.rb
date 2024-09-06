class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.12.tar.gz"
  sha256 "276d1dc498678fd8994d3b468e1fa0f06cb1f25652a3f9949d0bdd187231d435"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c428d7b70aa613e81de4cfd2203bb5bc5d45bc08223be8a138040e9bafec18f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c428d7b70aa613e81de4cfd2203bb5bc5d45bc08223be8a138040e9bafec18f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c428d7b70aa613e81de4cfd2203bb5bc5d45bc08223be8a138040e9bafec18f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c303a59618b279b77c7b8e901d2ec786aafb2d785450d44921d86191b5dc724"
    sha256 cellar: :any_skip_relocation, ventura:        "3c303a59618b279b77c7b8e901d2ec786aafb2d785450d44921d86191b5dc724"
    sha256 cellar: :any_skip_relocation, monterey:       "3c303a59618b279b77c7b8e901d2ec786aafb2d785450d44921d86191b5dc724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc350fa0d692976962640ea833059caeb6d25a880c71143724aa42c079cef384"
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