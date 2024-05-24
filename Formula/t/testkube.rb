class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.45.tar.gz"
  sha256 "f159e89305d3e269d2126a14c3761eb68dc759ce72227e34e0028c887f4c3f29"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6a99099eebfbee86af7d472d4e1e5dff93a103c6dd86c2cb1f7867488e4789b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d60c63983a8e0f58c8f681947555ff4341b61800b84289f8e8e922987184bd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f223df858a103120ed61bdae6d90877ebfb809ad05c1a0fc3cf5a3258a23232"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d99763f4cca447d8d1e31d4e2e334845a63e0d15b3505e0a10f291a618bcbbe"
    sha256 cellar: :any_skip_relocation, ventura:        "ba93ad9fb57203001d8dae39e529e65e5773b67640610418a5c73c0a851cdaaf"
    sha256 cellar: :any_skip_relocation, monterey:       "4846e5435be088a0df7a371841b6592d61c956d1ef7dd3cbdc4e58a73e17cda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a10fa3ff667008dd975c70dd7f05a419d0929239fe59d000fb01cff8e6b94c1"
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