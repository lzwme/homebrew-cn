class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.58.tar.gz"
  sha256 "13ad4084383ddf4301a7a6ac59aef2af5aa14528ae6f6b4410d3f7520e6a4301"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8c49a08b8c02fa045d625bb55acfbe16469efec8361bb85b8487901ba89f9d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d96be8e63f1c087ef918ee0018f5ffe14817bbcd1738dd66b610ea043a711af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce3678f48adb9d4c7db14cab862ab6cb5c31f86aae1182efffefdaf233388c27"
    sha256 cellar: :any_skip_relocation, sonoma:         "74681d2b54d043298f5c6b85627b0e2615b3d32419fa7b5f7551f8a12c9390e4"
    sha256 cellar: :any_skip_relocation, ventura:        "4fbdad1f8eb804b872987d21310f10bc3640ed0043887814efefa98da9b69d77"
    sha256 cellar: :any_skip_relocation, monterey:       "99bdeb63c28b2601521bd4baa390a022e67780286be7e8cabc571fccc6245c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6f140d903bf31c0ca11e9c075c3b076ec8d35e35651127a164195eb561168ed"
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