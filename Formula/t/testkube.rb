class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.160.tar.gz"
  sha256 "e989a97a488e5c5baa2ac16d7fe62dc9019af75739d787c19f55b52e03b4e168"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c4459cf6ce5849cf58169c649557b574c05aeb502701cb0a8037c10b2677376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c4459cf6ce5849cf58169c649557b574c05aeb502701cb0a8037c10b2677376"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c4459cf6ce5849cf58169c649557b574c05aeb502701cb0a8037c10b2677376"
    sha256 cellar: :any_skip_relocation, sonoma:        "70e0518af426e5872c65c1f46b1a88571ebd1aeb02847bc06c21b94823caeace"
    sha256 cellar: :any_skip_relocation, ventura:       "70e0518af426e5872c65c1f46b1a88571ebd1aeb02847bc06c21b94823caeace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a65db30dd959f045124053b3902273a739b940ce67b823f5fecfe52f7b2ac60"
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