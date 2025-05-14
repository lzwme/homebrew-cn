class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.151.tar.gz"
  sha256 "c2add33e2972afa180b1a659ff8bf6c6169f5a2c6133eeea8a4e8ac8a99d72e8"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f455954e3dbc4b5f456cb1a3e962b3fb50b48658018c85116d1726d5768503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f455954e3dbc4b5f456cb1a3e962b3fb50b48658018c85116d1726d5768503"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7f455954e3dbc4b5f456cb1a3e962b3fb50b48658018c85116d1726d5768503"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc88a59812508dfec41ce02a690d432213df463bab12446be0ce1c64cc61e4da"
    sha256 cellar: :any_skip_relocation, ventura:       "cc88a59812508dfec41ce02a690d432213df463bab12446be0ce1c64cc61e4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d65d1eb0931dce8b62f62e03528a0f4e224761052a9af47d9fc9e77a699fea0e"
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