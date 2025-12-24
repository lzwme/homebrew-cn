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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "216e67fb7cc4650d40ee3272014c1579577b2f607c06933c52bd7b2e68bdc71e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ac18e9e48a4a7c32f6d048f16e4af6fc513ad785b9b9416c9e34a4b4d69a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21dfb255c03737d81135e6bb71331ccd08fd4988e3e620f5779dfec70ec07829"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a0e646e1031a6324781865f0f1a58c204d33ed4b2f6b22dcc2abf42d79d2700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a62bcac5928b2aee34344ec99b18ab94aecf6f02845b556438f14bd3d8aac74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d9e0726c42c0d081ba624db61477eda766e1c0dd1015b35f82e9da508716c0"
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
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end