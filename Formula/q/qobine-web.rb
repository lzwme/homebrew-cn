class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://ghfast.top/https://github.com/sofusA/qobine/archive/refs/tags/v2026-07-15.tar.gz"
  sha256 "1e2f5c0353dc51609f3a4ff0feb1fc02c9da17646b1f5357e5ea6c05fd39180f"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cb45c641c8c72e952f78e37887855de0fec8f5bf8f7fa89ad989ad1780142e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61d2bea0d8bb2c75c03128da49d0510f07f59b98af09c55d50596ff2985e407f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd49e0cb9972218f53354c60701ac544fe1ee2cbb3290e43dfe3a40d12bc4b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b63ca310d7162be73b5542cbdc398b42a7dac58ef6ffb57a6cb202fb76dfff"
    sha256 cellar: :any,                 arm64_linux:   "4eb12b582afceaa01083a673a9bc1e15d3b5afd935641b7c053225a34be38eb6"
    sha256 cellar: :any,                 x86_64_linux:  "297c6ff1b3edd1ee4aed6e128b478d4a7a34fbd2e681319ec8b2744e010cae00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "web-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-web login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end