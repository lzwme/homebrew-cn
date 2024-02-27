class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.30.tar.gz"
  sha256 "1c79d377136db5be45772034d7e111ef789532729366327068f88ffaae48fe41"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a0d7ace1c411b29719403e047a6b149555f977e1665a4f84b84d05d0cdfb400"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fc4a2d793f539857cf22bcc60b726230d74b43c7362d10c11c0fbe55393ad72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27614955c17093d63a19b90806bb68bff5470447ce791185700de7fc828adab2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0dc7d512fb85cf65ad773868a782873a9b346581bf792baac4118e28e734563"
    sha256 cellar: :any_skip_relocation, ventura:        "08e3e0fa6559512d03b5040e60de60eb601afb709ff1945fa4042800f9ad40ad"
    sha256 cellar: :any_skip_relocation, monterey:       "4afeed0f0e201a9ff4f167582bb4098c42529ce191b015aedbe4557b5501a81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c28fc187ba0a1566dda9f3d07514fcaee39392e190e3ffff61ddd1dad9517e70"
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

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags: ldflags),
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