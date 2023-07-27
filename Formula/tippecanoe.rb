class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.28.1.tar.gz"
  sha256 "7d0371be8d95dfd883d8102e8d30c21ab4db2ed58539041712184a2c65704077"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29d28b916a5e8c62c7e4edc347f69a3f32829c9ffa0b75da8cab415c5b4def39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66d090db8920e4f4aab1330921c524973f74ee39013a3902d8db4b63a94b1991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75cf6feb209b7c5de294884c7f5c81500d07ac75eb3261a381dc8b05f3456143"
    sha256 cellar: :any_skip_relocation, ventura:        "9e8bb745723f87aab220346045cc30455402ec67d117a32481cffe9fd16b5093"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec5f5cd5600eac089e82b6e3507eec221e4d2782d0c8b0fcc72a0e1f57ba0b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "69011a935a7abc677456c33e5ab1bf748b15d2bc62fd635bee56bb13e48344a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d86f76f9abc37fed7d99d84c5c9b4c13f115d5db104b0c467191209f7a1495"
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