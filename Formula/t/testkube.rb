class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.10.tar.gz"
  sha256 "75bfdb07977b35109e8cdfd83902172acef0ae6ef4431e91301de2b179c95261"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a49fd8a86f16888d386f2e523a7d8c9c08cd70de781628f01313f08e1450d899"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20b0c39e7d9487c97c865b70abf08a1decccc72c2465f2035b766ff80598b0bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a212509a5212289097ebf70cbc55828b300eaf6bb77f9b5f4eb328e05408507"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fe455dcfc3dea3c1f14684335f82d5266569ad7ba68c350a48256cd5f7e194d"
    sha256 cellar: :any_skip_relocation, ventura:        "511cb2c25edcc396a017e9f1ba2b91d4a0e056e69667d1e1613fbf5bbc0774e2"
    sha256 cellar: :any_skip_relocation, monterey:       "af5ee0fa2f343e5d3945233e4020180bc4bddaab69404a6d509c94fce50b37ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e3aa3eabf8d2865b35651a8a7b0bf16467fb2774a19d8327e94253dd3ffefb"
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