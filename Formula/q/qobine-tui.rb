class QobineTui < Formula
  desc "Tui player for Qobuz"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92981ff6cf135d156f65740d90d81c14c368f9b9c9fdc688c1945f04a05cd222"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96743123c07c2cc2eae5d8f97ef11722f1b47f9aa184c6844ceed1e86f496dbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a407c310d2242f8989e48dac9bc3179a48016215827357c13db8cacbc287408f"
    sha256 cellar: :any,                 arm64_linux:       "9e2aada592385c8c3809cca516fb38a2c5cd48e031acc52d3ca6215116680c6e"
    sha256 cellar: :any,                 x86_64_linux:      "8b8c2f682e6029ee14e0882c4564d32c67f55c918875b5025908656bcd98f11a"
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
    system "cargo", "install", *std_cargo_args(path: "tui-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-tui login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end