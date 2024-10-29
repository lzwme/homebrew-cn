class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.50.tar.gz"
  sha256 "534ed9ab799301144ac2b42c9f241e82fcda6bee45e2cda21511c5fcbcaee1c4"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1fc15e0082c01dad65ce4dfb76fd7b9d253355d0d1ce55c697e59ec9b4b689e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1fc15e0082c01dad65ce4dfb76fd7b9d253355d0d1ce55c697e59ec9b4b689e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1fc15e0082c01dad65ce4dfb76fd7b9d253355d0d1ce55c697e59ec9b4b689e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8146a75ee300fbd091a0f8fb38f621e5f5acfb0914ef02096fb67d5a7abbe51b"
    sha256 cellar: :any_skip_relocation, ventura:       "8146a75ee300fbd091a0f8fb38f621e5f5acfb0914ef02096fb67d5a7abbe51b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69cbb37128c91edb91cb5b068b79faca731c953d904958d0e6bb15ea2dbd6cb3"
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