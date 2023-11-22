class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.20.tar.gz"
  sha256 "94ecbb0fb3a365f00b7ff099084d332ec539b3100f0d7656c2864996a13aa93c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7db42ae94299783b325c4fa5e91befde14af6c2e286755bcc412c61662482722"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f32e06602b2afdb96f49afde926f14b57c64be965aef3646a0918eca16f969d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "addd58fe23c7b561aaf3f1026c8b4efeab9a6cbc7a6c9803f558853a6e24600c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6cde351c00145fa804e851fa22cc56fe491aaefbd4e3678d489b07d1bed2740"
    sha256 cellar: :any_skip_relocation, ventura:        "3e05fa466373ad344d45dca16e66925fec4149007bc7b33b557863b4bbe03db4"
    sha256 cellar: :any_skip_relocation, monterey:       "78ff25cdb5be90a21ef815e07fd968ee96b14b1efa1a19a0f775befba299bc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d3b107cfe6f2388cd9e411726974e44b9cd087c88db9c16f4578c51d4b8b872"
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