class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.32.tar.gz"
  sha256 "55682a2406241c8a7ee6343198687af8bb9c0d7727466648b381dab92ef426e9"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf0a201fe6522a5520754e7f9c1627ad431dd8b9fe7155567e176e656aaf2a10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e3130946310e85d811afc3fa8c0a08c09296e1bb04844982df9fbf17524977a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9072229716d898c45b79b32d9e2d8256702b7692a5e6c85e847d28fec365c64"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c8a2f6c12b7c2e8f404963253e81d24e9a893dc0d2c0a79eb4920032d248d0d"
    sha256 cellar: :any_skip_relocation, ventura:        "6ecb6ebee0878130fac5f094902ae2b6cda95dfc0f4eeb460d8c647087052cfe"
    sha256 cellar: :any_skip_relocation, monterey:       "1257e41f4987f5b3dd196f4529196a7b5fc1fe75680edd4181ce5d51bd11247e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4728944a4ef006db7aa0ceda8380427324ecc69a07203379bb6c7368360b9edc"
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