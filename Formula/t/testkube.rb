class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.102.tar.gz"
  sha256 "8aa9a9d1b156c18c5283c67c6adcdac41bbade21ee73b825c2bff07d6f860fa6"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f75fbe7fd596b58051e693b981e65fbb9479c7c3b5399503eb2dcbda720e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f75fbe7fd596b58051e693b981e65fbb9479c7c3b5399503eb2dcbda720e89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58f75fbe7fd596b58051e693b981e65fbb9479c7c3b5399503eb2dcbda720e89"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c9efa125ae49a8e681c14b0e6d89808a681c1ca9107efd88fdb8bcc2dca42eb"
    sha256 cellar: :any_skip_relocation, ventura:       "7c9efa125ae49a8e681c14b0e6d89808a681c1ca9107efd88fdb8bcc2dca42eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb4cf5845f006d284dc438e253913cdc4cfcdb58ef0539f25bee20009414a394"
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