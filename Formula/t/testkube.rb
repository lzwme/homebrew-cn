class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.9.tar.gz"
  sha256 "bd3bba640618de5f23825775a67a1ee4305e75ffc10cead5f7a424f97f3291c4"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e1df9bfc7ef3d6dbfa6ca53b4d0bdfe3cfa9f165742bc0ef9e755b47dc5b239"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f37c9d33d7b33a787e521c67d0173d536fa6fb7849e9bd1bd708a1351903aef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1846a575a0afc3e89be41f356016b8fe7befe064df8e17097d6157a69d5062a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e3cdd8d5e7cb7025c736b3f911dedc132b65411d4caa90bf9ff39d27ae1c7a3"
    sha256 cellar: :any_skip_relocation, ventura:        "3802ab3f3dadd90f5c531367d1e5aec6c233ecbfa1dce54015998c310dca37b6"
    sha256 cellar: :any_skip_relocation, monterey:       "9f31892fccaec281fbe8074140c3b381362883267a79ae6c73139a024a571c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80c2e5972fa969ced8bced6b6ff1cc7ee7a4a372e61076d61312b19302831007"
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