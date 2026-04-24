class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.9.0.tar.gz"
  sha256 "9694fc9f806d3dfd34847b1ff98a3f41275897a3d1f3c505ecfc021600025701"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72ccdd9eed798361f1dd1e0a4ff047e439421eff99ef1736def05b7ec8a364ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edf0813ca02f133f7f21c9a18bfed88581b32dccead04e610a990304b41aaf94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbc190570f03b2c79cf2ad0118a6919179de942c6c334b76cc3fa483e2c6ceba"
    sha256 cellar: :any_skip_relocation, sonoma:        "17d8a75a5a23ef5b34123c149678ff3a8677da6891158af684e474d83fa8ab2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e336fc48313f6102d673fcfe960acab8bf30f555bc1666d7c1a79649d92500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfee27992bafdae5cd863eaf259ce69498db9367bbcd7fde34054fdbf848c4b8"
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