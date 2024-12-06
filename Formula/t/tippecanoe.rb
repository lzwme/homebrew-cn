class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.72.0.tar.gz"
  sha256 "e4be2a4ecc38ebdff25f7f292f259e1907684829a7f25dc8d19db25225c0c73c"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a28130b2930415b71cf1871a133655edb47fcdbd85b69757395069bb556dca7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4062556d90260f59919b6ba7496afa944a9baa9b28cf82d044ba87267db935d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5d9336783020e3bad43128eca7041558d21a8378049d2c26a53c9823a3b9fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f4e948acb94fe5c4ed1e08a2a58b13658d92461c47a03c99061ab7c9e9a394"
    sha256 cellar: :any_skip_relocation, ventura:       "62f521c809c10167fd725a62341433560e26e612dcdeac04672ef55685f1d765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a4d1ac15e54da461850e9ef9221cf9a8d041066de2b45d9bb52ba7bbf4c1b4e"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"test.json").write <<~JSON
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    JSON
    safe_system bin"tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end