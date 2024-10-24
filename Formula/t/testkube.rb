class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.48.tar.gz"
  sha256 "409b97e9300b532eaa48d042975fee5e6a581607d8e934f595f1b20f4d38b2fc"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec8ba145ecbb162f6fa805372fc36c3a74f4809abd97f6ad71d89bb7f9b06ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec8ba145ecbb162f6fa805372fc36c3a74f4809abd97f6ad71d89bb7f9b06ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ec8ba145ecbb162f6fa805372fc36c3a74f4809abd97f6ad71d89bb7f9b06ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "9792fef9fa70b42b78ddb6b83a8cb0d63d6fbc79757c15846a0efdc59bfef166"
    sha256 cellar: :any_skip_relocation, ventura:       "9792fef9fa70b42b78ddb6b83a8cb0d63d6fbc79757c15846a0efdc59bfef166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8c5ac1151e379f74eaed372c015ff194d0e930a98ad578003aebe3a792e2eb8"
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