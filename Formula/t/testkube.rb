class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.0.tar.gz"
  sha256 "73cdeb710eb6caeacfeaa8aad74e0c39e3f26818fd0101b20233495ecd3c5cfb"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b115f3937622beb9881a625d6167aa6639ab21a4ee930cecd958fb2957771f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d754881f4633222bb6431c0e496cc9fe2ee295177e321f92982c6355c321de1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d24e6bb060cb40c47f274b126a64137a66dab5e79723d3934640274f57f3467"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f55da51f501c3159208e4ae0895d974faae2f6791156b0587276fb37ed0a9b1"
    sha256 cellar: :any_skip_relocation, ventura:        "cbe7291da64f92dc13578c17a60f4971e3c572318a74b9e01377b8f31add9650"
    sha256 cellar: :any_skip_relocation, monterey:       "9da80ba857b3dcd2cb4b3f2689d908cf7670379f4f817a4aeeb8b77e804a2073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bf68120ebc0051907bfb34468b697cfacf2f5cb1b4b97cdc9fd61140fd7ffba"
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