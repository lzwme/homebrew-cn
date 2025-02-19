class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.91.tar.gz"
  sha256 "3c928f49eaea9a3395f2c45baed4703e9dac78f524dfb8070bd14d7c7d5baa74"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7fc1c097e2822f2cd182f494fab6eb90cf7ca6f1843c90dc52a8a62c74410e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7fc1c097e2822f2cd182f494fab6eb90cf7ca6f1843c90dc52a8a62c74410e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7fc1c097e2822f2cd182f494fab6eb90cf7ca6f1843c90dc52a8a62c74410e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4198cf046f395fb764be74901772f83ddd40d679379756427414faafc710c6bb"
    sha256 cellar: :any_skip_relocation, ventura:       "4198cf046f395fb764be74901772f83ddd40d679379756427414faafc710c6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "388d019a53603e6e9d9d76dc2f1515104b7c249c4120f9f01cfd4ba7511b482d"
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