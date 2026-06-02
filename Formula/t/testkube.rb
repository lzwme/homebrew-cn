class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.10.0.tar.gz"
  sha256 "f19ee3ee5c040469b6710693466a6244f6d0b63bb7755b1b886cbef8fdb218c4"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f24dbf1dffabb8478d1ef1a5f788ef03af0479c7e238f9a028ec2b10953cc3f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4715a256beb232c0dd082f3539efb1a154c1a4656f5fef40ec1aebd90ab741e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce49fe20dfa4440047322e534eb1d8511877426e459d283b151fc3eb5d1c070f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f285a4ce10466dfe7abc418268486a7cc0084448141e806171943df0bf2391d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6000301da1393f69afde0972b90e69257f3dfcd82f56bc71cc1bc7c384e6f3af"
    sha256 cellar: :any,                 x86_64_linux:  "c8fa7c5f287a010310cb6cf560eab688f51d56524a4b3ff880d66b553464155f"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end