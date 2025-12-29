class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.5.3.tar.gz"
  sha256 "1b7e7fef43c761cec51e9004f46376dd075c39999c82696a2fcc067a9b2481be"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80f15e37452f3a2d89dd0b91f65f14eeefd68b35c95f9d22f8032b0fda19d0a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0ac98568f23255eca4771a49514742e637900c79116950479fc012e06a70567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63ce28f437e1c5761020690abf8349d37b64e3b9687ae5d4393c735ec0d36628"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79a724b3fa53872dcdc69b4bc3dbc0de9e23b49d0a6431da3a7c63f2920992b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233d0abf568f38ae5f4a7b5925c8a1f23c79908bd902b767cda143a9cfa001f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ef31691379c8e005e5b01b4964e0020b5a86833b6d19e94068375441e404c3"
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