class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.62.2.tar.gz"
  sha256 "a0d3bc90a7ac77630b3cd5f0f26f4b19605514406ba970510b8ec1363452f8fe"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "669125225809c9d50ed0b5292ce743fb24f7814b461738912ebb67b51ec82f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "985a97f464d8e88171e84db3067c8ec1e780bdb153a01cc501567559815ca516"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bcd3528b22683931033b0b633df775d7f58307c5ab5ee4414dd4da11e8a0f36"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd96f2b732b09020e22903ed059bb0994fe3f54e5b43b55b321be3a50ac362b7"
    sha256 cellar: :any_skip_relocation, ventura:       "c1f2cfef1cd6587118491738c99389395347878ac93389c79693786b2fb4f2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22819dbed6c4446d7590976a3b7c09ec6b8fd564e41fc99c4f3d546fd4db3eb7"
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