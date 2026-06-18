class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.37.tar.gz"
  sha256 "5b3d722c88ff6fad0ee5c04f649b86a77543d929474990b8ebb1a34d4d61bb47"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d84a033b486855470569ecaf46d0adcbad392c6e4af5851deef3a402648e5bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d84a033b486855470569ecaf46d0adcbad392c6e4af5851deef3a402648e5bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d84a033b486855470569ecaf46d0adcbad392c6e4af5851deef3a402648e5bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c42c74831a082fab52470e17b603c82e4f7f27711608b15cfcd7e126259fb90f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ff25fa48de9ea6a5b2b2b6eea0b2e456dcfa1648db854a70be94fd5ef3eff8c"
    sha256 cellar: :any,                 x86_64_linux:  "9073615609e9cea6e650c74b3b5a585ba5d4eac295a27eaeef2b9663ca7a6bbb"
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