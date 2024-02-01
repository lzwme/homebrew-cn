class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.41.3.tar.gz"
  sha256 "42c59b2d6238f118d3a3d58787a45210f4d49236a74964a9c8f7359617dbf293"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c66290142c70b4698e4e9ad059d42027623b01f2d2a48d3b69bcabded671b7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66f70d6a020a6ab42746e5d11636ff6b18ec0ac8727f1a53ad3d61ad007abd95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f9a1847ae921fd5655a33534f2aad9a260cfa599bcef9f10b144e863acf51f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3378e077d09bbc3e4977ff1a1fa3c5d9541ef528498391df177f2efeefdd054"
    sha256 cellar: :any_skip_relocation, ventura:        "46d4ae268251e86ed3b29ae273c3d5984f52806a252d5f3c06cc6fb56086648c"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ccd5163f2f77c66bb0f772df85c10c2fadbdf5ec4491205692e117fbd24ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6052a2c833c77168dec80fc8d7ca1b9c41a81d3c3f492ebba9712d56a400b63a"
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