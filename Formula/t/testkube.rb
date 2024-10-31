class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.56.tar.gz"
  sha256 "790cc8992ce62626f07b66ae5b66a876642ccd69763b957ed71b232dae6da4bb"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508f3369ceeaa31b3da62f67d54e19477edccf515b5abf056a63b009f4358fee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "508f3369ceeaa31b3da62f67d54e19477edccf515b5abf056a63b009f4358fee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "508f3369ceeaa31b3da62f67d54e19477edccf515b5abf056a63b009f4358fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c13e03c0381742ebba9f75be2dac65ecf427fe748c56d764c1e445df6fd10b8"
    sha256 cellar: :any_skip_relocation, ventura:       "8c13e03c0381742ebba9f75be2dac65ecf427fe748c56d764c1e445df6fd10b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b8e215a52bed86064cc8d3b9c5cd337de987a61c367fdd66fdfa7724af9d7a"
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