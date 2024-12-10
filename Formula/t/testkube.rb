class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.73.tar.gz"
  sha256 "affd59b0c2a424c48ad51c921530e8d31474ed11513d76be59b01d2431fefdeb"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca9b1456f264b7c86b7e0aa0180884ec8780ebb139eeedb0189c9a8303e2936"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca9b1456f264b7c86b7e0aa0180884ec8780ebb139eeedb0189c9a8303e2936"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aca9b1456f264b7c86b7e0aa0180884ec8780ebb139eeedb0189c9a8303e2936"
    sha256 cellar: :any_skip_relocation, sonoma:        "38eaaad3dab8c16c40119fbf1b957a4a87c37da24d0cb6a09616dcb11e4e96f8"
    sha256 cellar: :any_skip_relocation, ventura:       "38eaaad3dab8c16c40119fbf1b957a4a87c37da24d0cb6a09616dcb11e4e96f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06793bd5c9c5908118d0464d9946ec3dfd2b95e769df09c05f5ee5b867cab72a"
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