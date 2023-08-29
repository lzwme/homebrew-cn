class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.14.1.tar.gz"
  sha256 "c15562624d2ad0228cf36b92090b2120020f9e5b7f88bb4759f860dcfcb95ca6"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c98ad269e29fa8327dd53bbce82c0df65eb758d1d8a5b72f795f72425b28b7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "907868f63d32ed4331f7ff4e2e00def4c3ddcd5db5496213d6742a4c2ac01048"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa9a80ca0b5340f19b76c5bcdd4bcbbeb2f634c53ed2b29ebcddb3bebefec5f0"
    sha256 cellar: :any_skip_relocation, ventura:        "6bd15cdc58042d5cad36cd413e6cca3227b028beebca3896c5063dd789ac73a6"
    sha256 cellar: :any_skip_relocation, monterey:       "d72bbfd605c46d8397de4e5084bfbadb2f899d0901b1d5c1609f701522e4a7ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f6e49c8cf865b721ec57e8be00f5f7d5744e0c8f9ec381faae02591679de533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce24314625c7d0a1c54b762284f8038937824a6c98f3cd62ac5ea54f2731b71"
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