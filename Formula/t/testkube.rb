class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.5.1.tar.gz"
  sha256 "abde44a3ce831b772cf33856ca0560b2686080358dd73e30ee730b19b4c8331e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5191e1403a2e88122070c7d758b073ed12b3716689e32f89fdad32806af5cf76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b298132dc021785579f486f71348eb89dc85667103d2ee220263a407a7cf44f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eaf6823cd3f39b01503be99d4a76650eef690890b8277a0beb07d8f5c3df0b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "360b532d9fb148be23d5781cf998331b7a7ae291903736680e44c6a52d0f0b22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5d37f6935214484a4695dfe275881bd6931757567d8d72d26f5b4cc4409f8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68f56003fcca8bb2e693a0ef58d5f7bc7602383fda7e09b5e84d4330cc63442"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end