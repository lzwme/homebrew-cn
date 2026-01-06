class CtagsLsp < Formula
  desc "LSP implementation using universal-ctags as backend"
  homepage "https://github.com/netmute/ctags-lsp"
  url "https://ghfast.top/https://github.com/netmute/ctags-lsp/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "216499e15257242c11449bdba0ea8b47fbadfc1866357c50cd6424a227d67910"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8203e4dae6c9588e877a59959fdf5b80ad1892e6c99f1b7eef2508deda574976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8203e4dae6c9588e877a59959fdf5b80ad1892e6c99f1b7eef2508deda574976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8203e4dae6c9588e877a59959fdf5b80ad1892e6c99f1b7eef2508deda574976"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec7d20829c8f217f837974d981f0d67d2714217e1df5afb5a1c9932a37755c2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d65b2f673ea20e4a1d5e16951da520c585e762883cc8a48a17666dca2e11201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b05ceac4fe282c3c4f860e6beb6ba5afe5a1d2af94a2fea486179dde1e93712"
  end

  depends_on "go" => :build
  depends_on "universal-ctags"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/ctags-lsp --benchmark 2>&1")
    assert_match(/^Content-Length:\s*\d+/i, output)
  end
end