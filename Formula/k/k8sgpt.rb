class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://ghfast.top/https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.37.tar.gz"
  sha256 "92b5de9354f68cd47972daad07ee7ec9c5e3aa2d543f1510d5560ac91dc761d6"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37cf83855e4d633b75dafed9a3694a297e5d3c9e017033c1eff4b3c2f9090aa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328a88effd10ea7ed9f94fe0fc33c16ed244f53a5b725ab226b54f5b73824ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71cca1bdd5b5a9c582df4b0aea8c581090d01b2dd1072c7e1875fcaad69e525d"
    sha256 cellar: :any_skip_relocation, sonoma:        "765906db37ae5c79a1140634ca8237349cf3625e65713961e7c32229b195cbed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ecff6407947a0d36ab26a84ea0b752fd5edbad70cbc14323f49f1009aba1398"
    sha256 cellar: :any,                 x86_64_linux:  "77cfa231e6c1ed09748192c095bf04b62988d9bc578ac6ef76637518370aff44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"k8sgpt", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end