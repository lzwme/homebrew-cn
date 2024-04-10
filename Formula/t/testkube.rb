class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.12.tar.gz"
  sha256 "fc78c22ed65c697a6ca17a1c8d9fe8cb4cb9b4bd3f10792c309e6e8f4331dbe7"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45c662aefa71ddcc410467d89943012726e1ca2217e6576cde49e52676dd4c0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ff2cf16e8ec4f5dc23d53db219e0fde6068f7a778f86921601ef039ad9673a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbc7e889ed76a02b381c6584b80254404bf734c8b913e8c23c8bbc7040e8fe5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a3fc21d93b758af0f3cb3c1b47079344cd253996ea17c50e56fd774ef0c75f5"
    sha256 cellar: :any_skip_relocation, ventura:        "e50dcb3eed43dc707b1a1f4ebe4248daa9e736eb2ebb46a621db490139f5877d"
    sha256 cellar: :any_skip_relocation, monterey:       "79bff4dfda897cb3c95449b347ceb79916c454931aaf594afbd79ee8e1bba380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a0893fe1e324d76dcaccadeefc514f669694b7c9ee7c521e053d95124aedb1"
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