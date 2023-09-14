class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.14.4.tar.gz"
  sha256 "bd424d4c892578333a036fd81774598cf3171adf379be85cdbe0c66bb4a102f3"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fead9484226d90d2f6566f7e36ddd2d6980f7b771b64eb011bc6d05ee55392eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b7d05a014cd6fed32c82f903aafcba9082db2f19b64978fb5847a4207fd640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd328476ab5274ee638232bc9b556b860a2a38a1b2bbe59f753fe4261b30ae2b"
    sha256 cellar: :any_skip_relocation, ventura:        "8407c9eec4f9d5c79ee7bd22cab0a22869e932eac10370e3bc488b0691451606"
    sha256 cellar: :any_skip_relocation, monterey:       "c469bb88b8cc36cbad97b89cd054f704e18c7c4a51cf825be064b1b437e28512"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe65ecf5fa0c72393267482dfa4e2df9c7d8fa19d1532f0a8d1526dacccd720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "088d2124a21084eb092cb08fd430e097c1a6e5087de5047162271b6a0db455e8"
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