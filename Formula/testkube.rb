class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.13.3.tar.gz"
  sha256 "a49d953a8b15203b4ecb76802c15e385e0d9440e8263f35c05c2c55d1cacd2c7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "074712b3bf9abd27579d0ac07677fcc027912e106ecfb14ca699c777a1e9923c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "074712b3bf9abd27579d0ac07677fcc027912e106ecfb14ca699c777a1e9923c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "074712b3bf9abd27579d0ac07677fcc027912e106ecfb14ca699c777a1e9923c"
    sha256 cellar: :any_skip_relocation, ventura:        "579e782c28649d1ef611f1935232dc4d48db07d7af3279e9eeb6736e7415b92b"
    sha256 cellar: :any_skip_relocation, monterey:       "579e782c28649d1ef611f1935232dc4d48db07d7af3279e9eeb6736e7415b92b"
    sha256 cellar: :any_skip_relocation, big_sur:        "579e782c28649d1ef611f1935232dc4d48db07d7af3279e9eeb6736e7415b92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54dc09b71e694b8071350fb55656061420c15aa7bde03e281d8b7de2c47924f"
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