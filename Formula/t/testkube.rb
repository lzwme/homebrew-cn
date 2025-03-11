class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.111.tar.gz"
  sha256 "9db107cae1bc69520b252b99bccc18de1f7b94a81f6b99daee7337e9f6ce5e52"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d21d57035e56dbdf8fd985cc09a09ee4968f120d8a8358761d20bf9ebcfb0de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d21d57035e56dbdf8fd985cc09a09ee4968f120d8a8358761d20bf9ebcfb0de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d21d57035e56dbdf8fd985cc09a09ee4968f120d8a8358761d20bf9ebcfb0de"
    sha256 cellar: :any_skip_relocation, sonoma:        "801eb8509796e144ad734f2f40aef332116046573728c3114af326fd303e09a1"
    sha256 cellar: :any_skip_relocation, ventura:       "801eb8509796e144ad734f2f40aef332116046573728c3114af326fd303e09a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6704d8e8dfb094c8d04359556e5430cabfa9b47e67242abe567fa811d35296b3"
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