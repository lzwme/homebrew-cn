class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.14.1.tar.gz"
  sha256 "179c029f7a244fb731c2c9319652ce63d0c19cdaeeaf33be1761d7fa79d14d35"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac405cd2178a7b5d8f68ca15acb6af5cb2336912e8dd3d7f5fd95321bd705179"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aba483c6869f250bad4332f41ed128800f7bf74fcd73f63cc8c07b5a629c83f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "606ce61c976d6beb4f092016ddfee17d8a292029a1c2ca96d3e1d2d25ef8c353"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d428d0fd04802aca304a65b367583c93eebbe4509390e2a2dd5b94c0d322da52"
    sha256 cellar: :any,                 x86_64_linux:      "34e4d1080b519098e8738c4b420eef07f3d26875772a1b96ca43b87e1a5ca753"
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