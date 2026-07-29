class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.18.tar.gz"
  sha256 "ddef3b9ce25d984277631ed802f8c23f210b88c4c02336ed2cb352eeb4cba44b"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6750fca74650dd983fd430673725a07774770f9c818f14d71edddb4248c63d03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6750fca74650dd983fd430673725a07774770f9c818f14d71edddb4248c63d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6750fca74650dd983fd430673725a07774770f9c818f14d71edddb4248c63d03"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0ed502336104b30137d87552bb2653762736c8d093a188b74a95c0aaed69df6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b953383b86c14692a7968ba3154eb97307dfd07720811a2f467a2fa78603808"
    sha256 cellar: :any,                 x86_64_linux:  "3213e899cbe86ddcb0fda9c3ca35d6ea47c4c00cc2c19c9cd0df5aa0a8395909"
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