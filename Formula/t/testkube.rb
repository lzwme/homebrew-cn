class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.12.tar.gz"
  sha256 "3af8894db7bda9ccdddbca13b2a1154f3c3fcf7ccbb1979ed90a15c72bc39755"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6a78728e548b355f97d759e73476a5b0100f2cf73b99a648da31b2770adee5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d002f2296c1558c950605539e49b75fae091597efa9550e40e1d465d4a7ed013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb4698f930180da14772c5c96a074b555e3ae535aaaa5ce26cff786da4365564"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c8948b638991a2505f23a82794eb6d8a1171042bc89382a142e47c9d43d00a6"
    sha256 cellar: :any_skip_relocation, ventura:        "7d8c02276986ac688a8bfe918656ba87a9636e73dd4cd41c154c88fac29daeb8"
    sha256 cellar: :any_skip_relocation, monterey:       "4e5b8bc6c4c3ff07e6923be7a624b7927f23511c2357c8e2cdeaf758bcc6fad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f89966e4077a88e8ea4c9fd98bda3261a31985d28d15accc7c38a4104554c3a"
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