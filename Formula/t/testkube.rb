class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.19.tar.gz"
  sha256 "fdee72a36100b21f03b7c6db889995d06ca4e2096c9e4dab742abb91bef1d376"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "50eaa4a1b2602c7bc304e9497c3aa653b005429971a1b820d0e471ef2b83dff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50eaa4a1b2602c7bc304e9497c3aa653b005429971a1b820d0e471ef2b83dff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50eaa4a1b2602c7bc304e9497c3aa653b005429971a1b820d0e471ef2b83dff5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50eaa4a1b2602c7bc304e9497c3aa653b005429971a1b820d0e471ef2b83dff5"
    sha256 cellar: :any_skip_relocation, sonoma:         "735db5163f3d93af8caae54e732730630a2fbf7918e9def223bc79a5c2a52bbd"
    sha256 cellar: :any_skip_relocation, ventura:        "735db5163f3d93af8caae54e732730630a2fbf7918e9def223bc79a5c2a52bbd"
    sha256 cellar: :any_skip_relocation, monterey:       "735db5163f3d93af8caae54e732730630a2fbf7918e9def223bc79a5c2a52bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f7737cd3125c4a034c2ae5b2fc691a1e52a22fc3a81e0630e41c003421ade2"
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