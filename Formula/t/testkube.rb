class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.14.0.tar.gz"
  sha256 "b27375fa870f63df104287cfb569d598600fada1eb2ab451d08fc850b7d399f0"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b610c77c0aeee627c0516da02714849ac305fc75aa18609c212f865725908bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61493a68eb2ba44a880a0a50c305c101682a3fe075b354b21e87e2d235ab95c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ce5c21427781c31fb8e4bdfed3d06cdbd90a33b47a0295b0c9839f0369661ba"
    sha256 cellar: :any_skip_relocation, ventura:        "129b3b18872ab04c7e63f8833a4ea6fdf7b93704620b8bbc16ed9d170293e828"
    sha256 cellar: :any_skip_relocation, monterey:       "f1fc3fa8b121a79a79f959ff9517e3eebc5bc28b70890c3bab3b6c3e35608e48"
    sha256 cellar: :any_skip_relocation, big_sur:        "849c74b2c132f2e8e6d97967ce3b52994fda33e2b32762e7e44b2f8e943cc43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daae9330feb473ee3a6e59a88c268fe1c7ebac74491f557bdf2ab2931b395c58"
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

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end