class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "7f60c2cd36c0e4160be1e8d36fa65c9406dba0d5541af70f7ee3b6dc2ec49521"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b793478f0867b5036bcbd74ad2afa656fc672a9d3847a0e835b612e952e2a53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b793478f0867b5036bcbd74ad2afa656fc672a9d3847a0e835b612e952e2a53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b793478f0867b5036bcbd74ad2afa656fc672a9d3847a0e835b612e952e2a53"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c5696dd1cc910c0a471705289347936fc386997fcd5ee27d2c957469c7ba975"
    sha256 cellar: :any_skip_relocation, ventura:       "6c5696dd1cc910c0a471705289347936fc386997fcd5ee27d2c957469c7ba975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "079cefd81d717e1fd299b7118f7b66a195e3f17484533550467c8b3eb698da68"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
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