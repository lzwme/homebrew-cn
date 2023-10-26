class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "f330fe6a71dda46159cfa006328c2d892ca3f62c8c10bbc1e709ba7fb0331a7a"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e394a783db33fa5286d1eeac5bec26480d1ca822e8b31c775d06b81838e1ef4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1665a7a382a09bc6d597b21e6c28864cadd0dff91579156039576a06fe3ebf1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "016b678a077d28495ad21bf68ba2c7db01829bc2d9079cce237839d78eaeea8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6384b6e977ab91372768773e54beff77958abddba28f6aa322635972f0fd0ac"
    sha256 cellar: :any_skip_relocation, ventura:        "c7fde30edf1acf0165e02a8c4b12b5d70b13cc44fa7811ae83ff80d90abc97ca"
    sha256 cellar: :any_skip_relocation, monterey:       "7d94664bc8467ed8375d76693c7d09bc0f55e82cc01df1c480d3856bfee268d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b249f632af381aa6876fcddd3637446995367bae75a92dafa73cb1816b8b726a"
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