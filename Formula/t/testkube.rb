class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.4.3.tar.gz"
  sha256 "b77c20a614e36b6e651336cec8e6a5044029e09e6795469d1656a900e2af8a70"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44dde573ffed2380f0cc381947b9672c5182bd14941ce23e5a944683140fcb2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0d1ecf349e52af7e9821c61f2dec87f0864971c8a8f56fc6041a1704c2dc3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f645895857f9d938a3f6334af1696c96e78f84a04b9257e9fe17b8b1d0abe93"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f559ba747aa5de366f805f63662c5b82d19e834be154404e95efbcf437ecd92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0c4658ff560752fea242400d1800cbbaf7a5f903bd40b3962afac9c0e01cbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a59c975ab6c96d0bd33b94597f05b7715fcb1d203cc2bbd72a138322ab77ea45"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
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