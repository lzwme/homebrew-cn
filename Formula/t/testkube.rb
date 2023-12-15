class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.15.tar.gz"
  sha256 "bd7b32d02359513521b554d898eb1459bcc1831618984fccdee672df101ba2fe"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4dd340bb0db1b78d79e139e9eb42efe4932b0e790a29c64e09ff7c29b83396c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45748ca2d7fc194857ba90df8ded74ff5c6a866b191054c5312a655691337064"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8f29d5e94700b3e42a00250c917e8ab944aec101899ce880633b623423cd6ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "924958cc21319438591280f181bcb8809ee2e7a548e9e5d654227ac9cdf2b84b"
    sha256 cellar: :any_skip_relocation, ventura:        "7f7b07719ae87495f85ad786d82572a1226ededba5330aaae45a5471b660697f"
    sha256 cellar: :any_skip_relocation, monterey:       "8f47b003cdde11bee6dd0af6901300cd61d7f91a3ac0b6f67c03f9492a3e7b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b4b53692aec28c049c5bc3d05eda75a3f78a8b3b3db938192be689cebec6bba"
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