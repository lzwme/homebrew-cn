class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.9.5.tar.gz"
  sha256 "1183f2933c01e9521e37568650ff5828c4a70622dd7e3303277c7f60d3126a32"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86ebe79336ab76088501ce3c4b683a58eb0a7afe5cc02614e2673fa931f473d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e5b5cd4f7464b883eaf9f1b7c45858309df4bf739e91dc2619f01ec8d12f7cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d6a7f0ba384b4b2f7092fcf3ed2ba8d4a0736ded35883811d5443284deb7384"
    sha256 cellar: :any_skip_relocation, sonoma:        "c220d42794fe0a9c4e107f2fc16a8ef9b41998aa1f88e863a51af744c97fb0b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc955c3c29b115e22a0d4edf6f35f75a83751fb966e4e733b7f35b8e199c057b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "474f86fa6f2952cd9f073b8029e692857acf9ca92f018cdabb8e7264d58936ab"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end