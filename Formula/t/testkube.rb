class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.27.tar.gz"
  sha256 "f4b8aa541710bf36e41fe4c9e01c29ba22d9c5a68840dfdf8e476f61eb641233"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "198f68d568eb2d6485cec131ccd8bbe1e4c7974558bd22bbae6ce8a3cb3870ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "198f68d568eb2d6485cec131ccd8bbe1e4c7974558bd22bbae6ce8a3cb3870ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "198f68d568eb2d6485cec131ccd8bbe1e4c7974558bd22bbae6ce8a3cb3870ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "7517eebf1ed7ca28b59f64f38eff9e5208da72f078c7ed8e991a232e27b89860"
    sha256 cellar: :any_skip_relocation, ventura:       "7517eebf1ed7ca28b59f64f38eff9e5208da72f078c7ed8e991a232e27b89860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff59d47e916935cbdea2770d2b43c81a534e6173b863d42715e9a1c8e201fe9"
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