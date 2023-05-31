class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.11.30.tar.gz"
  sha256 "4c87c49e28ce2c5528e6500640f1d78e5e12e7d3d6968452b2a0098001e271e9"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa1aaf0d2226932dab7d51c2f5d21f9677183cb1b6fbed10946d872773fec6be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa1aaf0d2226932dab7d51c2f5d21f9677183cb1b6fbed10946d872773fec6be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa1aaf0d2226932dab7d51c2f5d21f9677183cb1b6fbed10946d872773fec6be"
    sha256 cellar: :any_skip_relocation, ventura:        "452d7deec171d5500eecc62f151b07cedad9d12f12b36cbb1ab815a061167804"
    sha256 cellar: :any_skip_relocation, monterey:       "452d7deec171d5500eecc62f151b07cedad9d12f12b36cbb1ab815a061167804"
    sha256 cellar: :any_skip_relocation, big_sur:        "452d7deec171d5500eecc62f151b07cedad9d12f12b36cbb1ab815a061167804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81ce597f0be1e0a23e335b9fc25c26a12eb8eb4492204855b2b30ddbcab4d8ce"
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