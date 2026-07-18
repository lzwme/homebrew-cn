class QobineTui < Formula
  desc "Tui player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://ghfast.top/https://github.com/sofusA/qobine/archive/refs/tags/v2026-07-15.tar.gz"
  sha256 "1e2f5c0353dc51609f3a4ff0feb1fc02c9da17646b1f5357e5ea6c05fd39180f"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c9a15984be417d3aa160cfff1739a10c6d9a8066500a683f09ff2f94ad57270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e76b363aa82a95041fe278ee68bd356d3edea6b9a1e9cb3b1e8e7e2724a7806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c88cbfd45baed0ced93d07ce55b698e5c56737d17a632c5e3ec8b14805c9b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "094746d95ebea811059ee512a37e6652bf9b18674d7ea90fac9e3b94d4719231"
    sha256 cellar: :any,                 arm64_linux:   "3691065c645e59f96bfb5b7c7ee0cfea47ea86c6277bd5396718bf6a9198457a"
    sha256 cellar: :any,                 x86_64_linux:  "dc0ffc01a9d2124ed86f2c8d49c3a035883d1d2e949e435f92ac4f5c7365f4fa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tui-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-tui login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end