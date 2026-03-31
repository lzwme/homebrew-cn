class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.8.2.tar.gz"
  sha256 "0f74f11c21f6291479bbd08a924d091bd84e66de68d3ab26293d5c4aa3530221"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aac2c328bae97dfd97a135dd888c4baffc0304baffa9826a843258311d117dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2bab13d590ad39deeaf1512d8d72cb42ce0c087b05bac6c9a1682b75acd8a3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a5f1544f42c5142086bc318d946a3d3d3910764c779b222554d1b4c6c3d94ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0d8fc70fb4c24bb4524e3df80ccffa4b74b303eea183c6038333e477f42f833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84591ad1ea095dc5679cf8fd3f241588212f2192a04222d8e86f0df78134a087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "644240ef82e3b3ff51309e285f8e1a7c13d7036208953b928fb69169bea21771"
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