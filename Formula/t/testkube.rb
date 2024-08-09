class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.20.tar.gz"
  sha256 "89913f1691a6feaeb4d2086f0df847c6140e6172c3d7ce1c8b94739478bc2fb9"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d3e600f2c3d33e84fd54dc2214dcd24739fe9600d4ebd4cbfbfc483d8ee6c4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "722c82646177151127aa147a4fe96b28a01902e72b32227d34c0a541333435f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53b6ee94882225a4ba5786fde89ea1ad10f4337ac99675d7142ca48af6e6f96f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b207bc76124ddeec7f0698d468d79c14949d9ec1750e3fe38ff36cb7d50e836"
    sha256 cellar: :any_skip_relocation, ventura:        "4c7501a469c1860a2c3518f784ce0a646a621804b50bb33fdaaff22c359d41d0"
    sha256 cellar: :any_skip_relocation, monterey:       "91669f755e347a691ee8a4053369ec5f1a6e9e3a897fd6a51101ec61fa91b234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe90c384dc0893d4cf2d0d8d5a58f6ab92199f56ba95f08f844ffc19fdb7dd70"
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