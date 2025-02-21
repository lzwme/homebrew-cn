class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.94.tar.gz"
  sha256 "aa9e03b7b9184a949e25c64dd2a24bc1c4db4f8a92b31e2b267551bd70cb60ae"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "662b0fb565aa127a70990d486dfdd30acd519576a6a2975ba675354bd7d10ed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662b0fb565aa127a70990d486dfdd30acd519576a6a2975ba675354bd7d10ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "662b0fb565aa127a70990d486dfdd30acd519576a6a2975ba675354bd7d10ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d8fb76ef00982d5b828f0082c7a96a3d730695381ddb6d362c2edcdcafc11b2"
    sha256 cellar: :any_skip_relocation, ventura:       "6d8fb76ef00982d5b828f0082c7a96a3d730695381ddb6d362c2edcdcafc11b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baca9eae9f5e1ab8b44e46b72259cd36afd66c5d536843d00fd6c27d31b9fb70"
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