class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.95.tar.gz"
  sha256 "d95f9a5bbc2c164f34634b393cd093fadaa1e97cf0128cc99be94673366c1c47"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d11ed1849d70743962dbc9b1099fdd61436a1cf25c2f3aef4bf60cc8a62d3a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d11ed1849d70743962dbc9b1099fdd61436a1cf25c2f3aef4bf60cc8a62d3a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d11ed1849d70743962dbc9b1099fdd61436a1cf25c2f3aef4bf60cc8a62d3a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0e8512699eefa699a07187a16271d449f929ba855f2dfaa769332bce450a269"
    sha256 cellar: :any_skip_relocation, ventura:       "b0e8512699eefa699a07187a16271d449f929ba855f2dfaa769332bce450a269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f63639d027e7823f56b7d0f9b506b0f52e11fb3c1a34e9c8c7911b7285eeff7f"
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