class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.26.tar.gz"
  sha256 "ddd870d46709ee813de726f4ed406a2c40f18177d9c255355307df6d88b25b7f"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9ef168130b8ea3e4e442096b304ef51e383edd08e1ae14c813e77afe27684cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f03e076ab14f735369d9ec3d6a27de759661ddd1127c957a5ea35cfedd94137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d48a55b56b83706db6467dcd4c8d1b38f798273886e9f849ea9f67c4405216"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f806bfb78c68b23f838e502b6f32188ef35138e7531b04615fe8b7fcdbb75ca"
    sha256 cellar: :any_skip_relocation, ventura:        "0244af1412bdaab49b7f7b16c3d26255c9f0dcb2dc53020779453b4c37ed6bf1"
    sha256 cellar: :any_skip_relocation, monterey:       "b56e56a27dfc5545d4ef3fb182d4b2606bccfd9def3aed4dc85bc71e666e330e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18fab67ea01e287f27d7ec7348da462c1ef44f4565d92ecc6000c9bf45cad403"
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