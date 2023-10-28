class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.7.tar.gz"
  sha256 "3cf430fcaf21e5dbc3bfba353f1a8597f9e13592e0ed11d1fcbd93caf56c2546"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb5474a03528690bb901d4c3f1031c802e7bf951309223d8ed0d51d3e3e0faf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4afd51005c4c949956e0bfec359772d7b22e7ae78a0de7ffb2911f8262f5c6b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f849d9bfe4fb58a1b58190ed03e5c1bbe846dd56cff7b1e6ce6831f3805d231"
    sha256 cellar: :any_skip_relocation, sonoma:         "de317bff6352af73c53989e3dbfb9dafe61f7566f2ea574d7c46612cd25369c8"
    sha256 cellar: :any_skip_relocation, ventura:        "66c7a317a00047e461350e5363a82b78ae3c5f0fb0f5aae80e98b519ffeb728f"
    sha256 cellar: :any_skip_relocation, monterey:       "62219697a2488669ffc905dc46c98ce6ab9d6ebd37eb5301a410077cc3bad9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b44d35c092b5cf809c396f22bf4fbf2ac340a6645a8be544d1573b688380a7d"
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