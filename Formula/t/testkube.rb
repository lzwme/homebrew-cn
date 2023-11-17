class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.19.tar.gz"
  sha256 "c3cd249bc3e2b402a02003709a1c0d9b2639c0dab6b9bb800de1daef3ade3ebf"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f89d5e3999ca54d55086a2738287848ddd2abeef588d5dbbfe37db7657d41ab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42d4b6517f364f4aec7f114c3584ec06b00d1c3f220401ce16da83d0f9fd2cc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad0e143f2fffe050b35797afce0dce7fd59e3c8a0006ee8328a008fcd028388d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4c0f53d9059f821e33248717c73a30bafe10c2d149d18c1bb274395909bcd01"
    sha256 cellar: :any_skip_relocation, ventura:        "aaf6a8a31d2bc0f0795d7cf30f2f7a12f6010badced7eece22f8a55e4c942b33"
    sha256 cellar: :any_skip_relocation, monterey:       "480673896d8a665e5ef94d7602722f22d2ac113db91478ff94174a61bd624286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab8fffb02877c7d264e5720da138b8d4bddde2069c02f4ac10ce7f8f7febf5d9"
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