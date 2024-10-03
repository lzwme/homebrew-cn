class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.29.tar.gz"
  sha256 "a7df7ad72ba736ecc5939e5ba8cdced7208f7e678b9a219ddd7dad6dfaa8e8ac"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddae2a0314f29c860ad649d3026b26dffb808c34c63c65b2d2d90f2d475335d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddae2a0314f29c860ad649d3026b26dffb808c34c63c65b2d2d90f2d475335d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddae2a0314f29c860ad649d3026b26dffb808c34c63c65b2d2d90f2d475335d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8165bab460d8d5910f00044cb149cdeb7320169d901c571d04dbd5ba0574f00e"
    sha256 cellar: :any_skip_relocation, ventura:       "8165bab460d8d5910f00044cb149cdeb7320169d901c571d04dbd5ba0574f00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adb7687875135dc26f1adaf420dd3f38632cbe50c2e0924b18798a0e38201c29"
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