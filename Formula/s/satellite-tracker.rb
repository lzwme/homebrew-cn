class SatelliteTracker < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://ghfast.top/https://github.com/ShenMian/tracker/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "2b17176d0fd2ffb1aacd799c77a07c5ca3749061877ec4b7e9f60fcea022c64e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a02b3164fd3c6c8dcbed3f61fd0526143e665aaebe47df533024b8f1c04ebd1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f048d9d11c05bbfadee2030371c699a7261f2111780765fe66d64e2b4835a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08b7770e8c99ee5ba0f9256b1e8eba7adbe96ed9c8176710f679ef04aea8d724"
    sha256 cellar: :any,                 arm64_linux:       "dccf0e72a64fec30aeaa381c16a636fa0240e25dc6a175fe79619830212497ee"
    sha256 cellar: :any,                 x86_64_linux:      "29e9200f284e865f73acf4c4241a1585edb55222e969c73632816e8deac8bfc6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "expect"
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/tracker --version")

    PTY.spawn(bin/"tracker") do |r, w, pid|
      r.winsize = [43, 120]
      r.set_encoding("UTF-8")
      refute_nil r.expect(/\e\[6n/, 10), "expected cursor position query"
      w.write "\e[1;1R"
      refute_nil r.expect("World map", 10), "expected the world map to render"
    ensure
      r.close
      w.close
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end