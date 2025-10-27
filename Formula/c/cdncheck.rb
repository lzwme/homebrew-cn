class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "f2384a267bae95b36f77e766c2d275de096d2074f7a975efd2870bed327c649a"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb582bece0f7616924855db9bfd66eb81ea078b037171d8a4f6e91c2fead48cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b475403df46d4cbc889c13a50261b5db91b98c9d86ecbb192ff37e3cc5c721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660345a22bde2b676752736bd824bf717a314a20b28853066c4886e3788927a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a02e550da5f3e7b6158dd735fcc0d0644825d653ce56b25deae1e69cdc68c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fda15e81e5aa70f94fad137cd34e8f141c2439ea73584fb7414abd2bdcb6c0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "608d1a4014664d73fae03f7e803a1ec68382ac34709db1999e3b3330ebeafce8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end