class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "29c2ce55a8963a1493fd87810ced3a8c92f9cd83b9b622cbf503c5b7f86aad0f"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37d575061ad8b78765484288e31109fdbe5d727df7f5953667fb6c364becbf96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37d575061ad8b78765484288e31109fdbe5d727df7f5953667fb6c364becbf96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37d575061ad8b78765484288e31109fdbe5d727df7f5953667fb6c364becbf96"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04c40cc2df4667d6f0b3031aaee6dd07a98594a65750cc1fc4254a0874b251d1"
    sha256 cellar: :any,                 x86_64_linux:      "87f5a0af7ad8b819aba5d56b6d6f6c60fad5c1f648c4e62cc82e26a52fc337ee"
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