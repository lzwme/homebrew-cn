class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "bafb96843c7112505238adfd53ff6e393938d0524e1ab4f58eea2b16a75bf13a"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "606ec8719047faa7f802d21ccafaf475e4b348b3d327cf337aa237218ffea2fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26fb6b505107db89dc5949b43223e26e0d50ef16102a01aa18c70763604e11cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1ea34f64d84046de263af0df535dc02e1e2a158ce805db71382ef6a2e8fe921"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f0d44e99c4b2c6df24bf32192fc514c559116dd4364ebe9437c86f4edcda088"
    sha256 cellar: :any_skip_relocation, ventura:        "9f67fcfdf6b9c08f60a1900e0e25973726c283597de0f393fcb9c2e53a53b920"
    sha256 cellar: :any_skip_relocation, monterey:       "d80a5912fc57736b83f9a5480724b10ada338c19167a134b85e4bbe128e6c35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf51dc0a7886e1d5894491ac9bf423f2c983cd1f4d59d382abc735de0ffe57e"
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