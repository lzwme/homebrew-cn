class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.91.tar.gz"
  sha256 "9da81b5db291950f65d7148dfe56dbf5d4c40ea6e560053d41f17ba33e06ee80"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb0d7dd90820a65d5be3a2eec37b3bf72a5f8a4db31f05657d8f190b58065e48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0d7dd90820a65d5be3a2eec37b3bf72a5f8a4db31f05657d8f190b58065e48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb0d7dd90820a65d5be3a2eec37b3bf72a5f8a4db31f05657d8f190b58065e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7fbff927520cc10d1b9494236d158310c0e9aae282bfe597efa8fae7ffa9814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22777259d2c9c966138d2895b4797ba028fa2c83410b2f4bf65c9ee1bfab7a2f"
    sha256 cellar: :any,                 x86_64_linux:  "41d1e1811eade14683b28c8976fef132bb89b9f77a299f3dd813d66495c183cd"
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