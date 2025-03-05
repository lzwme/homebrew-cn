class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.105.tar.gz"
  sha256 "1747c1c48354a743aaf9498e1549c4ac2c26463a094605548504ea8692d8692c"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ceaa571f4b091c80f4c5aa14f8c36b2863d68786157e96535febce2bbcc0bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ceaa571f4b091c80f4c5aa14f8c36b2863d68786157e96535febce2bbcc0bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ceaa571f4b091c80f4c5aa14f8c36b2863d68786157e96535febce2bbcc0bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f84068d126d7d1b3d2a10611b2172c12db698be82346fcdf3054731f6a1e45d8"
    sha256 cellar: :any_skip_relocation, ventura:       "f84068d126d7d1b3d2a10611b2172c12db698be82346fcdf3054731f6a1e45d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a7c960800034e104c0199fab87448cfe525a171aba1741f50e85fd25c36d6a7"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
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