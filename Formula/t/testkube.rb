class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.85.tar.gz"
  sha256 "0e95a8f03c6e4f6f4058d0377f5ed9ecaf77f7e139756773ba2fe612fcb4b51b"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9640762c29e9f8cf70c487ef830401396520a05f2cf68b3aef235b2ece327deb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9640762c29e9f8cf70c487ef830401396520a05f2cf68b3aef235b2ece327deb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9640762c29e9f8cf70c487ef830401396520a05f2cf68b3aef235b2ece327deb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf76af539362bd564e5c83f337393a0329cdecb21f899bc280a9d159ce7cbcbc"
    sha256 cellar: :any_skip_relocation, ventura:       "bf76af539362bd564e5c83f337393a0329cdecb21f899bc280a9d159ce7cbcbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9196f3ad9a370c4ccc522c4640149c13f21e40b53da9440c219fb4d7d36263e5"
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