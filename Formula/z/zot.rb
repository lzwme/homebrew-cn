class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.48.tar.gz"
  sha256 "2f340e72c12bc4322c0316638303ec642fb2841eabc07b0613648662b9cc498c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59c7c6f4555376b09faca0434debdd58636d0d2fd41b06dbbcad297a5f223d74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59c7c6f4555376b09faca0434debdd58636d0d2fd41b06dbbcad297a5f223d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c7c6f4555376b09faca0434debdd58636d0d2fd41b06dbbcad297a5f223d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5703ec1673b0c248644a17fa25a452dbfaa1c67ca93ccaae77de39cd14bdf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef0d8f9dd97c0e8afee383b1a76ce567aedbb9123e6ad0e3121083800d8da63f"
    sha256 cellar: :any,                 x86_64_linux:  "a7d81395214728336938a49027309e731b5cb57927e2a831ed7b18d50a57270f"
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