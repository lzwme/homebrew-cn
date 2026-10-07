class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "155301eeeebf21aad344ce993daa27c6f9da2a9af828e68eb4e1a83c3834e0e3"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4412b8005ca154c6b376098748adb27e8d986a62b0e79254203fdf80e5ed2f62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4412b8005ca154c6b376098748adb27e8d986a62b0e79254203fdf80e5ed2f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4412b8005ca154c6b376098748adb27e8d986a62b0e79254203fdf80e5ed2f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f51dcfaa7563dc0f414eca8e7704c34a82a99e0c0708a20c71d02fd4ca500c1e"
    sha256 cellar: :any,                 x86_64_linux:      "36df890becbed65b9f44f298eaad9e4faa546b322f418012d53c6709e2b50f6c"
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