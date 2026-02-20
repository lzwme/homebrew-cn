class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.6.3.tar.gz"
  sha256 "5f9e5cc7323163ac16b2198b7a9aae67211902b979a16ea824083d3cb09473e7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fc0ddb311822b929356caa0c909691eb9bb15a32d6ed955ba72f7cbed3a6df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fb79a404ee1860a54e152f2cbf8c1f21f8653f56f77e1abb180a7ed4d9aaf08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "899eb17147b831277b7bc92aa320d9a212772321ac18961cc78e1437f0fbe92b"
    sha256 cellar: :any_skip_relocation, sonoma:        "647d4fb7fd5ece667bfbf0c1b6d510a55d5222efa67a40ccafd5ef35598edcce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5615bcfd948422d5848605e148a05dcbb204aad896bbd2187abdaa88615ddd84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c33c6709ac2cdb2a5e4dd017476010585ffbb1fe1abebb00ecbdbbba7fc03f2d"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end