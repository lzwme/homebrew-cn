class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.46.0.tar.gz"
  sha256 "bc311a726fcfe65f8bdb07851b7cbcec5135433a1634cb40ef32978930c7fc2f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac323269808a4a5640344064f34b6c8304080d6d5eb60d2952e358cef0a21753"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf48019d06bdbcbfe962a119b736319fe59eeff78bd6acbb55529d33223e9da5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5951e1deb0426e5e8ca965d70dca3d81baf1e22d5424d0c24a193c99e288e59f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cadd01e848a8339578d5ff9c0e699d51aa1aed935c28ec1bb71ec333c8c081a9"
    sha256 cellar: :any_skip_relocation, ventura:        "e41bb1ee68e9cc9121ca9626dca51f028c0cdb98430c67127d8f6be948773e19"
    sha256 cellar: :any_skip_relocation, monterey:       "576a14d803b331c8cbacc9eaecff4c73056ca9240c82c7e289edb52cd2a5d792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c11c8cd13ae3c9658ebb1b88d2eecafd959375249e8e8a8f0886e581ff84a63"
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