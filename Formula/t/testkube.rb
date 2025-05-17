class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.152.tar.gz"
  sha256 "30f257f1dfcf61522b9ebf62741aa2dd20196b934ec2fd4fe3ce093de8f1bc18"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39cf4c5ad35b1b61116e61ada1c58353a8b3097163ee5b8e5c9c402a803fbf2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39cf4c5ad35b1b61116e61ada1c58353a8b3097163ee5b8e5c9c402a803fbf2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39cf4c5ad35b1b61116e61ada1c58353a8b3097163ee5b8e5c9c402a803fbf2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6951d3ba693e24e4502cc2dfc478d19279491c34cda16772315f9d5fb307f7fc"
    sha256 cellar: :any_skip_relocation, ventura:       "6951d3ba693e24e4502cc2dfc478d19279491c34cda16772315f9d5fb307f7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1f54e254e31d1933a67877ae9e790918e56e66f6374a9f420d97589ed933c8"
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