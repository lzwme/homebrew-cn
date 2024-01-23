class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.41.1.tar.gz"
  sha256 "c585048d45041e8133981a87a4252f2834792cda75a2943d3dff048210ecb572"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d14b5360ce67aaa733f38c8436abcee53bf57e859a3d1d73355d73b46da73347"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b817924ec11d9b24fe0269465ea48e4c2e03826ca2950a4c91bbd047a9d5be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b58e485af7edb52c498881d1038f416a808637a4a99e188fecc68050ac56c335"
    sha256 cellar: :any_skip_relocation, sonoma:         "421368284d6f045a0f88048a996b6ffc8bd0ea2b843fd3149c73e071602288a0"
    sha256 cellar: :any_skip_relocation, ventura:        "972ed5f3c05ae257339fadd0a9ffafbc9b5ec53fa9117c8cdaa23a2a4a67a75d"
    sha256 cellar: :any_skip_relocation, monterey:       "ac660c9fdf34dfcd4944e7de4d38b37d691053ca8bb632a95a9fbd65f3871429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35533034fd573f5204f70b57b8be28c77822dbe189b873b4a9494db2081d1427"
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