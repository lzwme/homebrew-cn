class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.14.0.tar.gz"
  sha256 "d114c8d248e0d78dba39f2eea7103f8d093de97c049aac684c3cb2d496305c50"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d0412e05adba81d38561e4b31b37a6466fb2e1a9906a40d917ffe8c8b26ad86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a61117cdaaa8019233e669c2a4f20d819b23e6c678823e0c8e08355cb31add12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7209e919b65e0aa9840714bb719de59280f6534d104bc20290320e562f3bdfba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7741287326186e43337464b6f1b2ffdd12b132c129daf6ea272b34e97b15053d"
    sha256 cellar: :any,                 x86_64_linux:      "8f29a247aa12f5c620874dbbc8fb38e5e2482aa53622652188650feb73c2134e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.builtBy=#{tap.user}"

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