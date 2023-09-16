class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.32.0.tar.gz"
  sha256 "01f12bc82fd8ca1007cbc51031cf131d9b729dd74a6d22182edc0fbd9fde5c1e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c90b5f5297fe7992779dccd443fdba3b5184e9e788e16075bf8e84de184261cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0552c9c9d6348657874eedbf9dc111701c94148a1eb71de82342a05e894d400b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15b12e4123428aee4fc8ad41c58c93d4c688ea7b03821219253e65b858bcc73f"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3c977300aff2cc9030d67dc1587301b12a84350baf84d095bcafc2e81403ba"
    sha256 cellar: :any_skip_relocation, monterey:       "bb7a5b728a439ce1fd916918c3537e4b18a566ab1f1d3970eac1964aede4e703"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff9184c65f6ed0e5e93ee53dbec60912b602d0870e04b81d12b0e8f4066c00ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "109f3fa65af7f7e3b8cb2dd0f6a1a340e2b20928544cdd94a2832f48d594e1b6"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end