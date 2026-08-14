class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.43.tar.gz"
  sha256 "af06dccd01af3b3c472051e3e5e36cd8d8c93553e3f8d766cb9a806b8e21225e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bafea48d4f1ac27ed2f586088769f1027aa16e29b23b88567bba71fbebe4352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bafea48d4f1ac27ed2f586088769f1027aa16e29b23b88567bba71fbebe4352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bafea48d4f1ac27ed2f586088769f1027aa16e29b23b88567bba71fbebe4352"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fca5c299f0a7ae5243a9260b2b3284d6454a5969f5883423f5ccbbdda9bd258"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ccd9f609821054d5fe6b4043dcf27217518c550b6f43bd4e2986571cec468ec"
    sha256 cellar: :any,                 x86_64_linux:  "5e42107e1a6707ddd3966b0da63d09fe5acc9e5009b5992b0c39d8ca2cb97d0a"
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