class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.5.0.tar.gz"
  sha256 "3ba01a1b47bbf501aceafecb0e71aa5d5fb27f5456e4bd072d811246ef5e1601"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb51085e0fdcee30d4e5ea3d2b054b82550c1c9b27199650527d4ad1dad6ed88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f92eb404b6110999e358ad7c1416fe5cc3164d33d7d99c4d8a73fc986d05a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3afe4557eded1a4c53d21bcaeeb3ca6648a3fd9ab4de1d3c83b21c1bbbbeda02"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e2776d501f2c89f8f937444c4976f4acc0bcad5b4c417457e622d6557480451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba095c96b21f00de441f34e432cc604f656a2dc5959176a4f88b63b852d2b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72dc6955511a126fb868fd0eab5384a32f585aa82471d6f8cbb3dcba37927514"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end