class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "ca658aefa9d39656cffc8af2a0005bf27f9d61bc8d97afdb059dbd970cc89bfa"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40587c60d44115fe256e7eed2fac0d43a99d4c4ba9b0d3f73e972f6c776e29c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b392bf282f5faa2c97ba6dd3f9a992636e2dc65e9ec9a4f689b66f96e073583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9711e44996320359935e02f814cd3793fb5ac781c297cdf681e1260044e859e1"
    sha256 cellar: :any,                 arm64_linux:       "c7df2b7c87268e904589d6756b3c01907df0051c8622b02be806490618af643a"
    sha256 cellar: :any,                 x86_64_linux:      "b036ecba4d465558e9e3eaba9aafc5824f947eb49f31c8f7f80dbdb1013dea0e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end