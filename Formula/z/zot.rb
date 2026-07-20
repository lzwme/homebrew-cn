class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.92.tar.gz"
  sha256 "94d3a51d90cba8b74636e8cc7b0ead0ee58474cee881037edd922460c379840b"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c16afc84e98fcc1083576391d2c0467fcb5808a625c7f417ba24cf79ab5773f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c16afc84e98fcc1083576391d2c0467fcb5808a625c7f417ba24cf79ab5773f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c16afc84e98fcc1083576391d2c0467fcb5808a625c7f417ba24cf79ab5773f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d52d6b272187054af9fe3a425959595d46108337113bd15f62ff75f78f709655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "968fdc964ddbd0c865d5c67f87d67c604716fdc110dcbbf715f18f88be85a825"
    sha256 cellar: :any,                 x86_64_linux:  "b2a7aad64a87f071adb9249124bd9e04cc66cb51851d3803f87f2ee7d1ec836e"
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