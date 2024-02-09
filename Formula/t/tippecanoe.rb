class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.42.0.tar.gz"
  sha256 "c1598b218bdc62597a6e1a6964dbd589bda10f0a18a09166f87c86cbb089fddc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e1e958126e6f0295c7862b3f784f4ed23d97da699483277ead17fa9f0e1cdb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6584f680005b7935750b83e2d2cac0ae4a96528af8b7acc9c6500e4ca33c953d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf22b502fc3060daa2ac65232c09d86dd9fbfb278263315f571c5790ed180aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7aa544a6301921a5b31c911e0db86564c68aa75807ad8ff59db31367f7125aa"
    sha256 cellar: :any_skip_relocation, ventura:        "2292a07ab80dec60a4037522a48e25c00caf21056466599373e8299ddfe57be4"
    sha256 cellar: :any_skip_relocation, monterey:       "9a2b2f31a20817dd21a5fa9b3cba74375925864496a4c734022557cbfae1dc4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3624aa0dc6f1eb2de60d3d587b460087bc9884a995a2587be61c0e9717a1df83"
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
    safe_system "#{bin}tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end