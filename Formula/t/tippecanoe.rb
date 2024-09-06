class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.62.0.tar.gz"
  sha256 "2f9c6af80c8e201834d8fd922a27b84341932434f214d8a587574c5d1373fd93"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "353cca51eb35b177be894eaee09f302f6b29c64c6b1293822a8a07e9c961b86e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3bf28a1c9df3b6bb4c2d3609404d1aee45c9b141b6d130dfac41c01e355afda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba22770dd79bac876157637556402123f3de2d0528d54b3868ec22763e7319e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "efa73806f4c22d776dd67cf3da59860bce03fc88cd898cd41cc5342dbcac339c"
    sha256 cellar: :any_skip_relocation, ventura:        "9a220ee752fad2b99a4cad7927f4aa5b95ff056a6ce933b6cb726fba3854b2ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a87868ae20f48b83eb773f3a7beb7114ffb2a47c8aa365e1fb0564005aa38807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "330febcbd3fc4e6a7a138e025aec31ec093041f88e008ccaa55f2babb6c0b72c"
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