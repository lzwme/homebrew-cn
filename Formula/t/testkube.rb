class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.71.tar.gz"
  sha256 "684baba6b7920c27df198b1362007babc7a5a5b2bd787469be6a57c565a35d1a"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d973bc7a2b483a5333db4f971e15bef33c39de0fca53963c5430eac01134fa01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d973bc7a2b483a5333db4f971e15bef33c39de0fca53963c5430eac01134fa01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d973bc7a2b483a5333db4f971e15bef33c39de0fca53963c5430eac01134fa01"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c14c04470e7f33249d3202400fa028f881496d5caca72deb19033343fd03151"
    sha256 cellar: :any_skip_relocation, ventura:       "8c14c04470e7f33249d3202400fa028f881496d5caca72deb19033343fd03151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5480ccfb0af3ab560f458c2aebcd9a482cb428b64de71e01be4ed94371959aef"
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