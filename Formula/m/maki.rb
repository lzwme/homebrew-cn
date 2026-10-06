class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://ghfast.top/https://github.com/tontinton/maki/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7e70e303d849d0d6cd35c869237f427bf747a920517695d395769a8c4df2f191"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "22d7cf6cc2fc6992003057b11b30149316b3b243167c3840751df165961f77c3"
    sha256 cellar: :any, arm64_tahoe:       "a5a82fe3ee48d859a26d173cb3409639eb495c1eb5812e7abb80e799af96aaa9"
    sha256 cellar: :any, arm64_sequoia:     "7bd9b3e42401c864b076ca583898794771bc19aa7cc503064590b3c374ccdd16"
    sha256 cellar: :any, arm64_linux:       "a5afda64b31d5da0a3c594aa4b3197e0bd64f9dc6b106cbd3e510ceb75d5cfe2"
    sha256 cellar: :any, x86_64_linux:      "c884be9b28b41765f6e62117d105fed7ff7cf89d97ffd476b47ad1976878bb5d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/maki --version")

    (testpath/"test.rs").write <<~RUST
      fn greet(name: &str) -> String {
          format!("hi {name}")
      }
    RUST
    assert_match "greet(name: &str) -> String [1-3]", shell_output("#{bin}/maki index test.rs")
  end
end