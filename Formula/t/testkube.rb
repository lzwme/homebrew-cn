class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.9.2.tar.gz"
  sha256 "293ac4c498978a49e819179f263981700f3e4caf7a9386a256870f22b2b62c6c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0c592b61293080f2212622f1649ee2b673452409e83931e38a041c3d05e5dd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f13eb48a5e584b63f7a89d352d16db1106b9bcfb08cbe55ee95faab5d0c2a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6706b96f4f9a9803d211123b04514063a726a997c0cc66aa152f9d30f790182e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f206c871019673eaf88055d3bcf1339ed03c992b3f1a243bf981efe338c01259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb0794402ae903e4c44817d944d2e00fbf8177f742724286cd4494dcc8286545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "618a8c0007e9e5bcba2ce1b62acecac7d16b675892dce394f94ca84dd2bd6a02"
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