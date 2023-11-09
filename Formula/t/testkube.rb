class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.16.tar.gz"
  sha256 "2450cbfca3cd17edc00f9994de17a295ea4e1c534c635ac07eb88d88bbd79de7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "737e554a3fbc39dae0e775c6b16b739e23a3254894f3e3ad5fe9b7b8fb530558"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e4e84583ce1bdcf2e0a24a0df715206361dd23e9bdbcb138011dc9e81d41b9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff75187d307ddf0add9abfd3755263641288c8ede184a70eb61566d3e5c65ebc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d819f7e2ed1b7e2e255086b155f1279418d31de583fa4d25ce24659c054dbe96"
    sha256 cellar: :any_skip_relocation, ventura:        "be23ba7ef518177f1bd7cd85be316cf287f3951378e5c7fbac01627f7b4328d8"
    sha256 cellar: :any_skip_relocation, monterey:       "05e8e27207c55de6bbec483387c82b1eab2aca388a074cf500f610c0415d08ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e916869634a115300a58eb24a406ec095ec44388364a0ed2e5920b00b15e0b"
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