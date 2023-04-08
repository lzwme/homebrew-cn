class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.10.40.tar.gz"
  sha256 "99dd4501f45c840ede9bbadd1e9ddf2126aba7df846b30ed50892bf28a3b5d14"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c522335abebddaa80c89078ac501f5ceccb7f2563c4290ce0d20e40238210e0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c522335abebddaa80c89078ac501f5ceccb7f2563c4290ce0d20e40238210e0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c522335abebddaa80c89078ac501f5ceccb7f2563c4290ce0d20e40238210e0a"
    sha256 cellar: :any_skip_relocation, ventura:        "62531338973ad6410ea6860515feaa8c157a37156816146e07a704445bff9465"
    sha256 cellar: :any_skip_relocation, monterey:       "e13caa2a4be1ac2b2c02d3d43cbd59bb19e1e0278764f1ce35a9596ff0cc8e2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "62531338973ad6410ea6860515feaa8c157a37156816146e07a704445bff9465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc40b7c8a8bb172a0f50ec2a1380f17c68f43d8b7a85f7e4e9183d409ad71ec"
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