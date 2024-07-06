class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.4.tar.gz"
  sha256 "76828105fbb5e2898e29b9bb539955e98bb05cce9e1ea07d50644a13203f87ea"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae1e586d26d3aabb59c016996c983e358a26d34dedc9e0bea8ae44d73be9b9e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf71e7c1219aa058f20eb0f6df9089cfa63c2c29596a74f272d3cc3bd43f900f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71eb2ef773544ec06eb2e366878e08e03c0511ef13061577661f0daf9729a833"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a1bf1f9e257541077a48a99ea602baac77cf8ad65d62ac6bbd6f2c6ed940248"
    sha256 cellar: :any_skip_relocation, ventura:        "40ec454a46765c830ff954795eeb626ffb8f0ca5707b6fdb319a05485e22d6ff"
    sha256 cellar: :any_skip_relocation, monterey:       "39f8b42ac7b18812ab478d4aea98a1e67373dd6688a701f09a59cda197b79563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5bfe0929cde75dc34c3af3a542e4dc9261b4c3fbc57664b6769ac050cb3606e"
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