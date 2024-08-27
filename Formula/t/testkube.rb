class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.3.tar.gz"
  sha256 "8603b929face1efe709aeb67a32f3665bd7492fc16bad0840bdc08f8d65cc848"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1acc62f6202af4524240657590cda90c8b8d07dfd638d443ef206c12d663c61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1acc62f6202af4524240657590cda90c8b8d07dfd638d443ef206c12d663c61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1acc62f6202af4524240657590cda90c8b8d07dfd638d443ef206c12d663c61"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8d1ebace00d71bd530369ac294439c24ec00615ee218bc4eb486f6dfeaab9f5"
    sha256 cellar: :any_skip_relocation, ventura:        "d8d1ebace00d71bd530369ac294439c24ec00615ee218bc4eb486f6dfeaab9f5"
    sha256 cellar: :any_skip_relocation, monterey:       "d8d1ebace00d71bd530369ac294439c24ec00615ee218bc4eb486f6dfeaab9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391cbace21719ac3ee131548de390daf474bcc329cb61d3f113241f810c78c0e"
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