class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.11.tar.gz"
  sha256 "5daecb396820954573e09e417a7453e58f91154c602008a12c71ad64d1300842"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca7f6fa7df43b348ca9920687b55914de3971461d28820632d02b3b348e166b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "315e2210f38f466c57447b66976398dcf4c38deb99338e36c48171ea2929d6e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a18edaddf6cba620ab56069de40a8fabdd1d8745cebcae4f1da46fb3d1eb99a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "94deee3dcc78d3a55d9d8d34f73e2285e6ff0c22d5157ff9f05cb9af2b6c1648"
    sha256 cellar: :any_skip_relocation, ventura:        "0d0e367c5e5bcfe0af03cf3b29b168a41062ace9e893256ec4871682084553b6"
    sha256 cellar: :any_skip_relocation, monterey:       "9cbc718c2ff08c6207a052df208c4422c1c0e603eff10d4df31cd5edcc53846b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599772cd613568911867e75861ea0728be3a055333482b05f541a034a2f0bb31"
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