class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.8.0.tar.gz"
  sha256 "07514d2ea82ea07360d8b48570ae8ba5897b45ab4bf887bbbd58a053da6cd327"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09571a2e2558f459a826b74ab910ccee9ed2ec887f0a09e94b95414ecfe51ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3929835d04f5d56f30439c21fcaeae3c04a31957c0ca171167e42d6bae7a07ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c1da0996d82eb027ebc233907f97bea33c9a1f34cb5a32396ad4b3cb4549382"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3b5124641b15baf4ce26b99c0bc0c4a58e63f39c3fe6094aea11e86fa6df5bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6dac9ac4f3c660a672d7804300b869de2a6259de73d51c4376a1c1505cb4a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98d2e4b107b329c9e6ccb8120222b82b3aaefc530702e93bc02e6f8bc9c9369"
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