class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.12.tar.gz"
  sha256 "67ffb163eb8cc722556f1ab5a6891a9ceacf8f9da3784153cc6a5007cff06da6"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c430843bf3c5676bbb960987e112bae855ede8bfaade6d88ad4c1a88ce9036c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3eb19ecda2ed2c627b51a7918e7116345a2f0911bde9dbd74b392de5f72ea59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3019444dca4371f20eac10692a728e10df03e95d40f5dc65335c7f7f669f9a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "81bb0d7624bada583e18bd2314860fb6e7306fe8abaf268b718f9b9ac2b25e8a"
    sha256 cellar: :any_skip_relocation, ventura:        "d0b109700a804c46fbf2c939d5a953d2b45167681df1368645d9534a0a4eb397"
    sha256 cellar: :any_skip_relocation, monterey:       "3397f981f2cf3ca2a66449d4f2f2d5761cc073169088d53da72d7f81124e6f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37532f7e36bdcbcced8284e21e496303c49163195173f978674df9d76f3f8e9f"
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