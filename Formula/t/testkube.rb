class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.114.tar.gz"
  sha256 "fc25ec3bca10b44f81a9c389b339c49cf604b7181e18684ac3e82f577943159c"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c5d611d2e2d1a5e5cc7274c8cd08b365c68b4bb8187d35626bbf82a2528a1a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c5d611d2e2d1a5e5cc7274c8cd08b365c68b4bb8187d35626bbf82a2528a1a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c5d611d2e2d1a5e5cc7274c8cd08b365c68b4bb8187d35626bbf82a2528a1a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2380eab608f5ccfde58ed7e1d1c56a13336fed484ce08d7a81326956e3b0aec9"
    sha256 cellar: :any_skip_relocation, ventura:       "2380eab608f5ccfde58ed7e1d1c56a13336fed484ce08d7a81326956e3b0aec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7b53138b2cc71989f89bc2097f3f4ecd021e343c1e22de04bc99ff1251a444"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
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