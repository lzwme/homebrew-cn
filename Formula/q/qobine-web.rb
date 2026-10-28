class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://ghfast.top/https://github.com/sofusA/qobine/archive/refs/tags/v2026-10-27.tar.gz"
  sha256 "9c8145da3c56d9b1c33ed4d6033b27e564babd1065b4070f519957d13eff518d"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e578a92fb7842740e8f417f3f11af45d22142ae58d6678f85599e00552bf49f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b852e9d60088b41bd8299e2ac45cd551d7828f55025bdb10c3c74bfb7d5daa4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10d2aa4ceb10bb347492c2645669653379cf5c9053fd205126ba7e1968b789b1"
    sha256 cellar: :any,                 arm64_linux:       "c61b6affdcb6fd8c0d514396e0da0d6f89618340f678f45a99829057278e8bb2"
    sha256 cellar: :any,                 x86_64_linux:      "f752df9d69404160299ea429a6dd0aaa4ac068823e23f676651959e6f7d389fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "web-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-web login")
    assert_match "Login to Qobuz in browser...", stdout.gets("Login to Qobuz in browser...")
  end
end