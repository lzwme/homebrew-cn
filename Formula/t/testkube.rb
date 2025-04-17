class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.143.tar.gz"
  sha256 "2983c2cd6d773e6b73246f9d1f3de904520060a88917f4ba5ebee37b204de8a6"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c342b13918beff3d88648963df52528db9ea4d699b1ebcbeea9b073f3ef16fed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c342b13918beff3d88648963df52528db9ea4d699b1ebcbeea9b073f3ef16fed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c342b13918beff3d88648963df52528db9ea4d699b1ebcbeea9b073f3ef16fed"
    sha256 cellar: :any_skip_relocation, sonoma:        "869443f07f4f79546e563439645af363a379ffb8094608163e4b2a6465d3411a"
    sha256 cellar: :any_skip_relocation, ventura:       "869443f07f4f79546e563439645af363a379ffb8094608163e4b2a6465d3411a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76730b698fe20b8ec998f0454ac92fabed9f649be8f38e532e4c412a232ddafb"
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