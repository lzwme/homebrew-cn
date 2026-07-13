class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.80.tar.gz"
  sha256 "5f9a12e0943619ca88336097ce8d4bbb5476dcf97bf66d95d0b6aafc46db2698"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03fdb9c36ead176ed88edd7f35d03912514e926f5beb63b4b8c435a347fa9e05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03fdb9c36ead176ed88edd7f35d03912514e926f5beb63b4b8c435a347fa9e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03fdb9c36ead176ed88edd7f35d03912514e926f5beb63b4b8c435a347fa9e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeba11c6c74b196741811578f1930db94f129160cda3b444db2878794bd5c08f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "401980e17602ee2a238a2f0858479dcfb03c3911732a99edc55fe3319b9c145b"
    sha256 cellar: :any,                 x86_64_linux:  "2fb6f31adfdf158fa2ddaad3a047636a2a306c7dbf7c188ac3d1b7dc6a46922f"
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