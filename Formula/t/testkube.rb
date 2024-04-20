class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.16.tar.gz"
  sha256 "74503a385574564d63f176285f6446a34ea9443dc71bbdae12701397f6fe1b4d"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26349e00eeff2337d46cc6a448629c48dff3e2a7f9d0ab6692678e549a785639"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbb8a3cbed3be7c9d99f3adb0955e25e4ea4a5d69fff9172745c4da452725731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b1d667dbd3d616b95c866807ab3a24741972976b59616eea13a09904a8299aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee8ced592c7425467f12a4424afceca5444fed88cf77289dc67cbf2ee73c96ca"
    sha256 cellar: :any_skip_relocation, ventura:        "4c1d2ddeaf6e398af7183eff1250dde96c69f55033429ebf1d81c313ed676bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "35103493c6b61ae81031b1cae4876de7df2ff733b5675e15806af06597597c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dd6888a362352747ff056321f2fb229374eaa9219f3b512220eab6217974a48"
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