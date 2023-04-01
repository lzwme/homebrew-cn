class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.10.25.tar.gz"
  sha256 "bdb07fbb6f4d17981e66d70855f754bfbf32b6e3715621c6deff12fcdfe5a0bc"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd2a1e627ea8763d68c6d319c733055efeb213cd8f2a773bd72d73597cd1b6d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd2a1e627ea8763d68c6d319c733055efeb213cd8f2a773bd72d73597cd1b6d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd2a1e627ea8763d68c6d319c733055efeb213cd8f2a773bd72d73597cd1b6d1"
    sha256 cellar: :any_skip_relocation, ventura:        "c10b3a697b0f9712d9e6b04506aec974921b608a6d241cf8f4f3db8505677115"
    sha256 cellar: :any_skip_relocation, monterey:       "dac75d688128d1b91dc4b06342f4fff3c25c543c44df1a149d28de676ac831ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "dac75d688128d1b91dc4b06342f4fff3c25c543c44df1a149d28de676ac831ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e46a46578f930596c8ba2c5207ccbb102c0a6d3fd361013425ce5cf23f9cd87"
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