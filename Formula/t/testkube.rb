class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.15.tar.gz"
  sha256 "4989371055aeb0ade429bb815b58417180994427b27d43905ff01c541a9b588f"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f7bf751c215c02e3cc8f970321cb1a8462d5e11c4ea3f3b52c530458f7d5864"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2be9a4864d9096bb7306f9b2143ae37e0293ed6f596b8d6d94f9374039f1690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4151b907e9dfd1d7d59c0f33e732a04271dfb5634fe86fb6c54d066b99863367"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae7f6a66d3398f29bbcafbc62ad20ed709b3df6190e4fdb6299809b399c7242d"
    sha256 cellar: :any_skip_relocation, ventura:        "0093ed4dee947a6d799ce912955f222ab36c9dd0c847257d0c3256a817da7201"
    sha256 cellar: :any_skip_relocation, monterey:       "cb80de30836b49fe348954c33a97bcf9b981cbba0b233cccafa26d06073b5d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "655ee564acafd5c5f4b1e96774e526e7ac932203b0302c71c326eca603985b3f"
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