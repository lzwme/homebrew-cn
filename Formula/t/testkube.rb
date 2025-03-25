class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.123.tar.gz"
  sha256 "82b393fcc3ca7ad310eb07a361acb98836337eca3fcba9586d1bc64c04a110ea"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0927741378959fcd635d49b587d3649eea846f7d1106b3675af9fa5d704e6a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0927741378959fcd635d49b587d3649eea846f7d1106b3675af9fa5d704e6a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0927741378959fcd635d49b587d3649eea846f7d1106b3675af9fa5d704e6a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebfcf674bad63e66ddc98ed2c0512e2e4ddf4d4f13d4dc6d2df4c3ef45599a0a"
    sha256 cellar: :any_skip_relocation, ventura:       "ebfcf674bad63e66ddc98ed2c0512e2e4ddf4d4f13d4dc6d2df4c3ef45599a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ad5e919115062c41ad7a51347638b0d7c531085318a9878ccfbefe080e375d"
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