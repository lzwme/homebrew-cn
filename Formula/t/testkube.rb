class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.93.tar.gz"
  sha256 "c9d366f8fc378596ebc7dbe35a2ad331df403424000f4611a96e6bc710742c1b"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "842a6ae2760f330f2b348a3b410e5b7b08ccc59accedf5ea03ef1ae37dbd1bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842a6ae2760f330f2b348a3b410e5b7b08ccc59accedf5ea03ef1ae37dbd1bc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "842a6ae2760f330f2b348a3b410e5b7b08ccc59accedf5ea03ef1ae37dbd1bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e661aff91b5af7b0abf2a84586389c7174f796b6212f16e3c43b5e520d9f32eb"
    sha256 cellar: :any_skip_relocation, ventura:       "e661aff91b5af7b0abf2a84586389c7174f796b6212f16e3c43b5e520d9f32eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbca451b9733485bc53bb2bff7855a29b3a4077211495bd4c8054d178bec699"
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