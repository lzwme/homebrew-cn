class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.13.tar.gz"
  sha256 "5fe5d75b05819a24bb780ca8069103e281d25565ae21493e914b6c5b7ecfedab"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95b91f05d92a2d4ea4f0f1720317927aff9a3dc1027af951e51db5e880f32034"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cd3c5587ae2d2f8c5039a3fca721e149f2d041aeb3ebb40fd8c9c14abdfb6a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6292b560fed7f07a5b5dabd7c427a959294a83da82e9cb171ec42436bf74eb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "cccd95815f7c9aef0f8271b297d0d1e6d4033d8fe3756b5200cd4c6e333e433e"
    sha256 cellar: :any_skip_relocation, ventura:        "83dfc4443bf8ab5c6a443712dd826f41d72af595382c9fff1c103fa00d1d81a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b2d28154ffb51498ce527cb0341edee9f6f8939c2f44ae2f3d7a1ba1c73402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86278c325157cf0e1f79ef712719c906b07ca0d86b47ee665f25dff8b6f5fa51"
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

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end