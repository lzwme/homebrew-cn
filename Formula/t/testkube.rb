class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.13.tar.gz"
  sha256 "0f9fea82f5a4d62d8941a01b767244fbaa3b9a5604f4fbee18c95c36ec3bf76b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a344ea5b8d7a944cee7a7f4a8f123055a4c4eb3e134d6417abb11a4258aade47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4ff46bb421d4bc094968be5cd6dfaa180f17867e9fb5a62c42ca49a22784ae3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82c17d501365b1bcbee7beca787387295363c6f66fe2d7ec282a0900a5b56e74"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7aa7f33a02a7638edde45a7965968d5e354b1ae913b6aa4df17dddc4571f5b0"
    sha256 cellar: :any_skip_relocation, ventura:        "7388a5cf90c37b713be8dca7f74d55477573544ba566ece24a66bc5cab964124"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb6bc3728227007f9ac6483fcdc9ab005dc6c17e7155c8ea23678a8d439c396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ad93758fdba7edb32021738b283fe5634e768c1470aada0183416239a1f02bd"
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