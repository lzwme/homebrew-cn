class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.5.tar.gz"
  sha256 "3b13bbc23e6907efe41d4f4344699455fdb86d0b689a53f91f5cad5e753895ac"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e34c68c17e83864fe21f0a109efce6691a322d80a3468eb2e7ae061de9643550"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04bc90fa236726ede2daeaa72936ce0a626f52218a8069017e65b5349be40096"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d005b01e7a2fdf67c2ade7cb4b76e51f239fb5a3152801cba9cc4cea5a071d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dde6695b2f6af5502fa129a6eee64b25a39d2f9bf2d9b2eb39ca1e7f21d74a1"
    sha256 cellar: :any_skip_relocation, ventura:        "87187738c2fc19c1d52f8fa9968ccd4e3c725fdc177d39b7355a3f0bf6167b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "4a958baa773a52e820d90fd2f4e2c35adc762f3346f99dc277e3c341caa7244d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e83da3c9723201dacbaafebe74e8113bd62948327d4673ae55ab2e6b373550e2"
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