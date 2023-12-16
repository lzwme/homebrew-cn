class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.16.tar.gz"
  sha256 "290e4996e8f6fbfa626d930d40e507dcfd50a24653a4d16bd0fabf3f294b1abe"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fa59a43dc35edeb707840869d8763e28652c699016f9a5cbd22047b96aad270"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff7c12cd9fbe135415081890295a931179267e969b297666ab165b4b7ea4b36c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8fd4de03b727d75bd99a08e5df2fda7a365dc50a3b3e5ab5ae062215c8ecb53"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6cce4d10e73d271a2fddcebd9db310cbe8db2c38d271811366dde7210ed1801"
    sha256 cellar: :any_skip_relocation, ventura:        "e196127506579416cc62764805d9682aead033458a02f40ac8be60c4a4cc789d"
    sha256 cellar: :any_skip_relocation, monterey:       "844e4569effbfd0ea23deb21b2cacd9408f6588d72d1949863279ae219b96c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb565657edd970735820b1f7b28449200b5d1ea277c403e070cb779281bb543e"
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