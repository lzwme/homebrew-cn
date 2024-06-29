class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.2.tar.gz"
  sha256 "324f3969a1556749e8837e29571c9b5dcb93c8ffa4aa94e8cb73c5cd2b605ee1"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9a9db37e06845112a7d717eb00e588ac1b440022ca2699f1763ebb7a79bd472"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15fcbdb96b969abc6d2b357b1fa54bfe94d90b5c9912921b6d437717fc654162"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "001070a50cc2b05ad8d9c94c8916bdb6879918bdfbba4d1fb8686feacece7b16"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6bc82781807b9bca63927d74188e3d75b599314126f5c9d21e8c4029cc741b3"
    sha256 cellar: :any_skip_relocation, ventura:        "6db7b3c8f9f7285a9057091d77d70283381c914f5ac1604db0ebfcae1dba6a5d"
    sha256 cellar: :any_skip_relocation, monterey:       "88f95051a3720b75f1484baa5268c312cfae26df3f9dc88fdcd8ffd5a4307a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0bd6c9849c44260001dd783d6c3549c821d74ac485008b72122917b68bd186"
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