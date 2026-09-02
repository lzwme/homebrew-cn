class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "87e1eb319407a5f8a9060fbe68b79dfaf7eb6b49a58fd4c66abe0a8865f05a05"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eef7689da73d275afc0a49df104ab1dbe5c9194214ea7e94681267877fd5d9d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eef7689da73d275afc0a49df104ab1dbe5c9194214ea7e94681267877fd5d9d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef7689da73d275afc0a49df104ab1dbe5c9194214ea7e94681267877fd5d9d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ff510c7d86857d127e1eb8d06cd9dfe1ef68900474fea64adcc86cba79711f1"
    sha256 cellar: :any,                 x86_64_linux:  "cd5507ade78f252ac392764ecc4eb8b944c06cc1632da1f3d31df38a06867306"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end