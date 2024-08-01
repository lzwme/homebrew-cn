class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.17.tar.gz"
  sha256 "07d1589c4c567abd915920f9b9b9cc8c54ccbc76b9ccc85f87242ca5899cf642"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af4c463e51c9a4373ad4f2f0b5dd2cc24c8a75eaa5858a362fa7fd21e1feda6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52c43490fdace21e1204a187bb670b93f60bef90df7bebf16eb59e84528f875d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d67aa9c0ac22c45156f43d7d6a6df4e521c31231e623ade3d832bf4d6f808bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "5108876f0bb7ff597b8c24f8c2e263c2d3fe1ed6331e963080fd62575fd911d7"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb5026b40ce5f72d60b9a7bf5b1be72f89f40c93dcfb4f2f574717876fc2a72"
    sha256 cellar: :any_skip_relocation, monterey:       "bcac4d1de4e472eb34b035e289022c055e900c25d754b4c34a38978a5b8ab331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe5c1e44797f8be5553aebea6dcd9677a92642c7ef99da44ace0c983dd370669"
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

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end