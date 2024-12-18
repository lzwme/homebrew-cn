class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.79.tar.gz"
  sha256 "667af023b7d34e593b86a01588de9fcc781f229b65f140584e234fbf7f0ea0c6"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2107554395c29df408cddcfb4c43465d3de6490ca7d94e1a4cf2b51422e4b307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2107554395c29df408cddcfb4c43465d3de6490ca7d94e1a4cf2b51422e4b307"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2107554395c29df408cddcfb4c43465d3de6490ca7d94e1a4cf2b51422e4b307"
    sha256 cellar: :any_skip_relocation, sonoma:        "7095f98bc0364d5287c28e6e793eccfb96b25e88606528e325ccff60dffd3295"
    sha256 cellar: :any_skip_relocation, ventura:       "7095f98bc0364d5287c28e6e793eccfb96b25e88606528e325ccff60dffd3295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44156cbbb49704ac3506a50f66cc1eb165ffe02e909dd7f21ade1d78ba77263"
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