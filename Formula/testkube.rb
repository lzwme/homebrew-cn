class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.13.10.tar.gz"
  sha256 "f511a4571171e2200cf93a4df946e91e7da9db79db205683ed2760891ea39501"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9dac45f0843db2ba23d1a77b50e8430c19c54065d7f8c272a09bf851782adde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9dac45f0843db2ba23d1a77b50e8430c19c54065d7f8c272a09bf851782adde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9dac45f0843db2ba23d1a77b50e8430c19c54065d7f8c272a09bf851782adde"
    sha256 cellar: :any_skip_relocation, ventura:        "9a4d7aeac48960eae5bda932a947a5445a0a450178d700012f61d2406e350a28"
    sha256 cellar: :any_skip_relocation, monterey:       "9a4d7aeac48960eae5bda932a947a5445a0a450178d700012f61d2406e350a28"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a4d7aeac48960eae5bda932a947a5445a0a450178d700012f61d2406e350a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1822f7e5e88b6fefc9304109e76db951fb82d31e0537e087738b4a0308924e1"
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