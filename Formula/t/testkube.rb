class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.138.tar.gz"
  sha256 "228f33f59d5cf6b2e5b387e2af75349091e31e536ddb9048220552b8e9487069"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4548313ad9c81d3cbd15a72c2b43e026b295fae1e281fc81b5a61e5be692ef4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4548313ad9c81d3cbd15a72c2b43e026b295fae1e281fc81b5a61e5be692ef4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4548313ad9c81d3cbd15a72c2b43e026b295fae1e281fc81b5a61e5be692ef4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a916a21c56e7a3f26ac0f18851fd7d27465642687112275143e01d941ab13f9"
    sha256 cellar: :any_skip_relocation, ventura:       "4a916a21c56e7a3f26ac0f18851fd7d27465642687112275143e01d941ab13f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a073a01119e6d42baf5bc66a1abaf608242f54eef1653d4d2a77a3f64124e7b4"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end