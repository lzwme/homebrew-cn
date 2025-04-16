class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.141.tar.gz"
  sha256 "684a61cee54c68e5e172d8c62ef3aa75a2df12e6af9bbfc988b1b7f418cd50d3"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79ad5366b7d6788821e9bb5feeed64f5497d5a21ccdb4ee6b455e4e77ab85346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79ad5366b7d6788821e9bb5feeed64f5497d5a21ccdb4ee6b455e4e77ab85346"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79ad5366b7d6788821e9bb5feeed64f5497d5a21ccdb4ee6b455e4e77ab85346"
    sha256 cellar: :any_skip_relocation, sonoma:        "023a7b23c0e14b9564d111b810c3358753a603518f57cdae5657d7a6f31d7c2d"
    sha256 cellar: :any_skip_relocation, ventura:       "023a7b23c0e14b9564d111b810c3358753a603518f57cdae5657d7a6f31d7c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f9aa091ef8370fa960adc58de9b1c15857a150ce88fdda9aa506a43ccd6645"
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