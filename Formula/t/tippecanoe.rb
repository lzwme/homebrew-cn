class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.62.4.tar.gz"
  sha256 "0ceba3a7eb92aa108bf8cbac9cab13393041e2e15c0120f3559f475e204426b3"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64818a7442b0ba12ae140e9b526d24ff4d8e935fd0467b73883ade9509d70d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9c1c482bd82cfabb9bf1382b3d282c77a11481c74971742cde635d27129a9ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d7a1b414fc4adf0e08d04ca34e877c3ec841054fce045e17045146b3818f14f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f6527c035f766fecd757fbea2c54b21a889e6b76cf92d8a5bdc2c11a1e519d"
    sha256 cellar: :any_skip_relocation, ventura:       "d6b63b952ee8712632ad0fd477f34ee4437d3366e41351115a72b82a1c81b396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef2a0fed5c3ac52f7fa501789e85b9868cd7bac7a7590c12ffb29c8523f69f2"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system bin"tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end