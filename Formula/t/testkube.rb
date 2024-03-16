class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.2.tar.gz"
  sha256 "904389d6bd0bf4174d080d923ba72b33c71c3247c4b1459b13e76932bd3ad5f4"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f8ccc64bd5df5b7d31aef9d53aceb2a71fff370ba29b1f1ab59b4147e841417"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac74aa6ebf689235e302ef1e26c43c0f4e347ed1ae7023c2b9767e8033c2b6dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7566ab728c74a89fde8af97c9622b8c1c2fc89d1880deed7e173c4e6598dd8d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8df3a5e385d65af0ed604d891b00432c320fa25fcdb73a7d425670fc0a4306f2"
    sha256 cellar: :any_skip_relocation, ventura:        "8d6e94792352c420bf6510fa36a0172efbaf73101013fcea0d27b2c468cb1b3d"
    sha256 cellar: :any_skip_relocation, monterey:       "e8052eaac7c000dd5d490459cd3c4b9db0c06e4ecfa6ec02d664da5e1cba4fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f8c6a39cd25dd037179fa2fe7f487714d705eeeb4ad556d219c1d54f470ada3"
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