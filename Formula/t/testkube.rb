class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.15.2.tar.gz"
  sha256 "98143e063467a2aad2d8100362d01f42bcedee5a01e0f20f8306224fcabbe093"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e88259a851114329e81a43536fb91550ecf331ad391bba86c5980ef1e257d091"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da5bb62d52ad81d451bf4dd30105815a194435d5b979691188a3d9d17672ca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30d5cd5da27476e9cfcf59d86467a2548b8af9a109956890eee0bd3a4407f2f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b20b3290bc364b8c4c32ba81372094224d6e3bd30c877c4eabb3d251931fdb8"
    sha256 cellar: :any_skip_relocation, ventura:        "b8d51c0290857d07693a65c7f75cde09b61a2a9638c745ae1b882623ba3d1891"
    sha256 cellar: :any_skip_relocation, monterey:       "6f17cb1929a5e02b2fd6a6cded97a19a769ff3d888b1839e89196adc43fe56f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7088d070ce100b2ed7fd5d54bf49cb2417716a906b009977bf3bf37434cca887"
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