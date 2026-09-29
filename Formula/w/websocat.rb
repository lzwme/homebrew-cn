class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://ghfast.top/https://github.com/vi/websocat/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "5c976c535800ca635b72839fe49d0fe4ad2479db8744c5a00f0cf911e4832e2d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5606fa8542ab5bdd17d28cde0a4752e893dca6cac1929ed67bbe85bf72dedffc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ed50390813937d6c5d900263ca1453be8dda74e7f0f0ce34dce44b2d990ebb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55e3ed26ad23f3edf03558dc5ff37483522a18701daff6acb1e491a4d0ee5d64"
    sha256 cellar: :any,                 arm64_linux:       "fa3519bfc7f2ba940effe6ae99cdc6e1c7dc40c02b0b4e7bf6247099d7e4e74a"
    sha256 cellar: :any,                 x86_64_linux:      "5abe0c310158004de8a2688f0778ef483bd8ade5ea3ac4f367e387fb4711ef61"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Backport support for OpenSSL 4
  patch do
    url "https://github.com/vi/websocat/commit/aa8fadaa212c2287067b722d4440b4f4118b39ea.patch?full_index=1"
    sha256 "5957930d4c4df80305b3ac15412f7be18438025132d1f77208d77499eb0e6f0d"
    type :backport
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "ssl")
  end

  test do
    system bin/"websocat", "-t", "literal:qwe", "assert:qwe"
  end
end