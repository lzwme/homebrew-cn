class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.71.tar.gz"
  sha256 "dbe160cf86c135bfa4d0d32b58d390bf85c0fd0e022e5e4ba9823c04255c7b90"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba76c909d36869071b99f8e138634083bcfffd034f85a181873703bea8408551"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba76c909d36869071b99f8e138634083bcfffd034f85a181873703bea8408551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba76c909d36869071b99f8e138634083bcfffd034f85a181873703bea8408551"
    sha256 cellar: :any_skip_relocation, sonoma:        "da4eee8e19224adb2df00f709c54010d409c11573817fd6bfee27e64c2542b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3acc2dff552c666753d8b47905efe55699285fa47bbc3007dbc74e2d607c4d99"
    sha256 cellar: :any,                 x86_64_linux:  "9adef6e3afeb3b03419248183599b7690a41d8680505d1d609b51d0e7eb0274e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end