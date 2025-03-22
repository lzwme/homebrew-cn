class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.121.tar.gz"
  sha256 "c001540a064005f591dae236f4520b9f2b1d2395f9637c270015fbbc4cecdbcf"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3797feeb823d8ed4f6d7a1258ae0d394787b415fd9030f10d3b479063bff8fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3797feeb823d8ed4f6d7a1258ae0d394787b415fd9030f10d3b479063bff8fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3797feeb823d8ed4f6d7a1258ae0d394787b415fd9030f10d3b479063bff8fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "29aff2c719b23995e44aab112d857a56674f84a1bcf51b17106db49dbb4f3cd9"
    sha256 cellar: :any_skip_relocation, ventura:       "29aff2c719b23995e44aab112d857a56674f84a1bcf51b17106db49dbb4f3cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d631dc03a432c3bcb82e72cfd76d90e19edb591edb32330ec2de7550ab3f71"
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