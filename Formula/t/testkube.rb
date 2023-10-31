class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.9.tar.gz"
  sha256 "517ea95ccd6bf944a88a84021d39e74602672343286f92a7286990c96718de37"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2023a6b544e926e83c808a8eabb973b76c93c03373a27591ee615039db4bf80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be47c07e1846ae4fbe7994eca11dbbd950ddc4d3492a55ce3591caf0d416f69a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b20f3bd98a66aa8888cfae2b042eca37d9c93d006cc9291c0f5587c2ce0879"
    sha256 cellar: :any_skip_relocation, sonoma:         "8636db6336455f0e209fb2da8513f9388d8ae5a21e0a8d42973444cce6383d59"
    sha256 cellar: :any_skip_relocation, ventura:        "25cef033717cbef18e87a483d32d4d4d128da1076ba0a4ec110442de6efbaf5e"
    sha256 cellar: :any_skip_relocation, monterey:       "823a06e9b78e7717b4a4e745c0c5374ad963dc1a0c161d5d806f79270fef373e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c87965e9632941ca41754661de203f8b70423c054d5f88fb4be23fc9fb88263"
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