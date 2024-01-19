class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.24.tar.gz"
  sha256 "31e900297ac9fe7638943804e76493ec46fb1354db823e29b95661b7882aae5c"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5e6c69be1105374f7b30c655ae00f013b03687f5c0e3adc1d064bb7d395f991"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f17c1ea1617493599dc928414ffdfe0ef859d4d51af750bd6d944e08d0a0049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41bd6f34c1685de92173265b90d61b3825b5d676309f4f6a8d678fdced4bc167"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2b14ce03b629e96aea534e8f97fa990301416751e4059765dc5c3c2599c80c2"
    sha256 cellar: :any_skip_relocation, ventura:        "c2e3783c09febef04f8c42254a214ed543b5bfd9801ed83bf67a28c5707f3e02"
    sha256 cellar: :any_skip_relocation, monterey:       "a5a3238b7905937338c65d24906c4a97da8fb2adc5be0adcefd675d018e9b252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59a377593f26001758fdfdecd61dd3be4efc94f3f3e3131d2516deb5cac4f51"
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