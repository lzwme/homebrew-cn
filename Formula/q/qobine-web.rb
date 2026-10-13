class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://ghfast.top/https://github.com/sofusA/qobine/archive/refs/tags/v2026-10-12.tar.gz"
  sha256 "8662611505a903300d6364fba5f4436d4ee5231639e49aa0095640420820669a"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de8719721d2b192b2403ed110590985159cf443b862e9f66c7d27f8fc6f965d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31775dfbf01e26b628f9dfa5cba7a94c3a0969d857d74d692b86a8a9e2227f1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba1d14ddeb597dc097d7217a3c7eeef9c2db3122cea1356677eec4b52570b2af"
    sha256 cellar: :any,                 arm64_linux:       "0cecb935e868a6b490f13e9812abe88ac8d93c56c700b3da6fbfbfd0e8687ba0"
    sha256 cellar: :any,                 x86_64_linux:      "99f8bfcf888b8697b94cdaee4b85e04c64afd05c0901a39171920d3c4c96673a"
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
    assert_match "Login to Qobuz in browser...", stdout.gets("Login to Qobuz in browser...")
  end
end