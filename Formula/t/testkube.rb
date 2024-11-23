class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.70.tar.gz"
  sha256 "c133c2a96ee2cff59f0336dfd27e20a11d839e9047f6d65fd6354f5291ea9a38"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e7bddf568a798db44365214169a02626ecb04cf5b821ae5e8e29a0c36a31bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11e7bddf568a798db44365214169a02626ecb04cf5b821ae5e8e29a0c36a31bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11e7bddf568a798db44365214169a02626ecb04cf5b821ae5e8e29a0c36a31bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "00744f2531ac97c3cbbfb93c8abe275dd9816e7e04ee928c7cf1c902fee7606d"
    sha256 cellar: :any_skip_relocation, ventura:       "00744f2531ac97c3cbbfb93c8abe275dd9816e7e04ee928c7cf1c902fee7606d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d1f21d6e4df27f7e593caa7bbc037bfad2984b6a10a69aacd4448b2e640035"
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