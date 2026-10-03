class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "e14600108724dabdd0a0e6da8e8ab1dbf65cc07bc06ff9c1dbdba74fc3b1b29d"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa7a3687ae6623934beedfb6cab280171c1e63f1af6661ce7bef102f3fcf58f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa7a3687ae6623934beedfb6cab280171c1e63f1af6661ce7bef102f3fcf58f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa7a3687ae6623934beedfb6cab280171c1e63f1af6661ce7bef102f3fcf58f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "288743d1f6c5782035936a2492a62467c8c7693575d99f8c9912561a35aee26e"
    sha256 cellar: :any,                 x86_64_linux:      "7da1c0b7fd79d09901ef16baf040f6c4d706934eaf4d0e2e2c3465925b3272e1"
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