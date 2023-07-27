class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.13.4.tar.gz"
  sha256 "133db9891bffac1d83154ff7017a9abb0b427946b0b5c1d00321adae3d3a1dad"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffba2674a1c55e430206894d41d892210af8027f2189f1a4c1715575453292a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffba2674a1c55e430206894d41d892210af8027f2189f1a4c1715575453292a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffba2674a1c55e430206894d41d892210af8027f2189f1a4c1715575453292a2"
    sha256 cellar: :any_skip_relocation, ventura:        "78884b7f26fb71dc2d6e3fffd51a78138d6f8c0f79a16ef61ba4576b8edc6b40"
    sha256 cellar: :any_skip_relocation, monterey:       "78884b7f26fb71dc2d6e3fffd51a78138d6f8c0f79a16ef61ba4576b8edc6b40"
    sha256 cellar: :any_skip_relocation, big_sur:        "78884b7f26fb71dc2d6e3fffd51a78138d6f8c0f79a16ef61ba4576b8edc6b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079451c5fd0ac305d503d28f98776af92e81fe2a3a93bf9478f5dbb9288ca6a2"
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