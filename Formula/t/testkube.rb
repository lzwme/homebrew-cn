class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.13.1.tar.gz"
  sha256 "1ce0f02021362eb7b6f046c89c5408828223b6d0ba2240543546ae477f76ad8c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cb1dacd447a3fa6c5379c27793e06692128af4b9df31efaf399ff434117e2ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8f31a823f2a6df450ba8032f003b4ed68111c8a92f3dcf233995dd6eda5e0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "939910f8a095133af82926a23f0d075ff962578565a67594d53fcac6f9bd933e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da9f14af722ede5c50f4d4d20acd7b709127b9b64a07662733cb555aa78cc6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd0d9923e29e06252e7ae4e5944728c97fddf81cfa53bbd6a7d8d957d2719fc"
    sha256 cellar: :any,                 x86_64_linux:  "bf5048869af63ed873f160c98d841608d8717bb8e7cd5bf4c3b891abcb34a4f2"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-X main.version=#{version} -X main.builtBy=#{tap.user}"

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