class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "6da4dfd6fcea0a9cc5e8ac93ec0115ad59e1d39ac933d4fcd8a0413c2eed3669"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "509bf032d9abe9f902136ecfab0ad7f9d797b6b3ad5dd7810db5824de7d15504"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "509bf032d9abe9f902136ecfab0ad7f9d797b6b3ad5dd7810db5824de7d15504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "509bf032d9abe9f902136ecfab0ad7f9d797b6b3ad5dd7810db5824de7d15504"
    sha256 cellar: :any_skip_relocation, sonoma:        "8676e3495e8f60ed90c5539704a26b77740fc14a45630ab935f6e7b072cb554a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d4daeb41b202667d0eb04f98873ebe3207b50813c76b74573fd57fd42aeeb3"
    sha256 cellar: :any,                 x86_64_linux:  "656075f585a947f80b4663734e8efcd35eb4f65bae03ad32252ad431b56884fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end