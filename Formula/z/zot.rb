class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.95.tar.gz"
  sha256 "5d78211d547fee3faef3d008f2fdb3b0858ad5f1f0a2f497fae61154d1600e07"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5761bf2617d667eb4401d459652421acd45051d423f63684d4df2c1716bfdb74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5761bf2617d667eb4401d459652421acd45051d423f63684d4df2c1716bfdb74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5761bf2617d667eb4401d459652421acd45051d423f63684d4df2c1716bfdb74"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed441a02235b1068c648b861e34b0fd5a7235dfaf6e462d5708b263615d4efc8"
    sha256 cellar: :any,                 x86_64_linux:      "bd0cb94df9ef466a5f433852fea1439745934914ec06879515c460e5de2b4a8b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end