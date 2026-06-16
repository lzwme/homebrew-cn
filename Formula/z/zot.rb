class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.33.tar.gz"
  sha256 "988a5e07e52940224c0216014d79f2094aa66d183bd69599cbe1a47d1e2e00df"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fe2efba767a4fe602066b6facf72a6145e1087a7944587a5d9faf2b00f4c37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fe2efba767a4fe602066b6facf72a6145e1087a7944587a5d9faf2b00f4c37b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fe2efba767a4fe602066b6facf72a6145e1087a7944587a5d9faf2b00f4c37b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef98f502dfb94ebabcc7e179c5540966332d894402128bd81cbae866c056940c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ece1f406f3d7dc2ca7f0124fae30bd59c589a4762b16b3c41e79766bf34ca72"
    sha256 cellar: :any,                 x86_64_linux:  "263e636c29c68d897ef2ee0b2896d18b110641f6dc114f6bd975645167115808"
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