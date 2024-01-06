class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.21.tar.gz"
  sha256 "9e0cbb595c0bd458b134a0542e2c06e6816ff4b61ff0a579112f41475425211f"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16283e0347aa14fec1c12e30d4d5868dc3956745985622d611935867f978e605"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f303fa1c2af8969682a614fa295b919bb6eef1cd35594ec66e7e753e688f867f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a918b2e626af40605b882a41c5833e96a702ef9c2f457be126ab123199004bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5fb2d08543e398d9954b1dd5def5cb76f4d316597d7d07878d8b0712986b543"
    sha256 cellar: :any_skip_relocation, ventura:        "a5238443356402159677aac98383c9e8be44f59de2b5e5263c9b1cdfdd074d52"
    sha256 cellar: :any_skip_relocation, monterey:       "9452bbf0688455b628343765f610196612a723de1918234207f48d7bdad031c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcd60c28161de6653cee9f62442208f5ccdf46cd2e6e3a197e52941814d9c469"
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