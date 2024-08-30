class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.4.tar.gz"
  sha256 "6ac250a7bf843fb9bdfa8025a8562aa45b78189f163832523421793f1cebd5f7"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f33390444d3c67b5bf345030e402836c18e7e10fc746330d269ae494b6fa4a92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33390444d3c67b5bf345030e402836c18e7e10fc746330d269ae494b6fa4a92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33390444d3c67b5bf345030e402836c18e7e10fc746330d269ae494b6fa4a92"
    sha256 cellar: :any_skip_relocation, sonoma:         "03a00bb76ce2efdb1350bfcd39d0a865da605e1e4ddb302af0dd4539864bb6b5"
    sha256 cellar: :any_skip_relocation, ventura:        "03a00bb76ce2efdb1350bfcd39d0a865da605e1e4ddb302af0dd4539864bb6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "03a00bb76ce2efdb1350bfcd39d0a865da605e1e4ddb302af0dd4539864bb6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77cd78953f9ab8818b5eec99ab9fffa68b342bdd117803471cd0d94b8cd61443"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

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