class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.11.10.tar.gz"
  sha256 "df061b3d2c202613392b59954bcea37479403467b9476c6d2e775ada412b88b1"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24ac2e315335bd9c19495c25a379ecf81bfd86f40718d3086858e8773077f303"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24ac2e315335bd9c19495c25a379ecf81bfd86f40718d3086858e8773077f303"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24ac2e315335bd9c19495c25a379ecf81bfd86f40718d3086858e8773077f303"
    sha256 cellar: :any_skip_relocation, ventura:        "c5ff890e686c5c3cba4dff72b4466bb046c86a56f12869db20d8cea6e3dc82c1"
    sha256 cellar: :any_skip_relocation, monterey:       "1b90609d18bd61e8e20f20e925299ab4106c3f9a7df5f9342205cd75994a4c5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b90609d18bd61e8e20f20e925299ab4106c3f9a7df5f9342205cd75994a4c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f009448fe290083339bfd4cdc8897c38b4f30d3505cfa88a79c52c6c560d89"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
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