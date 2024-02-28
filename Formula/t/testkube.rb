class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.31.tar.gz"
  sha256 "eae9f99b1b143e927d892516eb83beba7a2fd164993182809f25f11da5db2e5d"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f1306aa1a227608cfa4aa93fb56493162d4be9096213a47609f862047040c01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b14db725a2bf43d22f704b6f1f7b252aabe536b6e0752ff7abf70778af7303fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41622c85cc60dabb06bc4179a6a247da0791406c9755109adece91dc38adc5fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2f8f143a005b66fe4166ffa774092784444da2fe642957fbd1f3b5289a6b069"
    sha256 cellar: :any_skip_relocation, ventura:        "7db499116a2202a8fb311312dfd1b5fafa85d01155531afd57ad8edeb97f0557"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7b14a825221a377597254a4195407cb39666b43c91c8b8db12813261f2e477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd3a4783c0c39befa6a024acd92844500075cecc957dc3c9ce833d6b30f579de"
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

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags: ldflags),
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