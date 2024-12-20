class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.81.tar.gz"
  sha256 "1fb4bcce2fd4c6c9c0db3e62d5a0d97977ebfed3a073d614120302003f280a98"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a39f2db639df2693d807054b567b92a64b5eec79d4b4ddb666ce6b5cebac62d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a39f2db639df2693d807054b567b92a64b5eec79d4b4ddb666ce6b5cebac62d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a39f2db639df2693d807054b567b92a64b5eec79d4b4ddb666ce6b5cebac62d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f180d2a16646a3e717613ab30b9a54523bbab7b60117fd4b662b643271ed0633"
    sha256 cellar: :any_skip_relocation, ventura:       "f180d2a16646a3e717613ab30b9a54523bbab7b60117fd4b662b643271ed0633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c058e067e9ddb70c97d40096d79ef358553fbdb7d877d3c8f20a40969cfffd"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion", base_name: "kubectl-testkube")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end