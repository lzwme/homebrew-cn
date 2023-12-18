class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.37.1.tar.gz"
  sha256 "2da1dba2786ef1c3b888431c95731ea32a776742ec06b1b9c4c8a98677a91915"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1197355f0f1d3dccb4e1ffca56f6ea187fc9b2d5cd41e29acceb3493842b8b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d9bccc3b1e56cefb5c11fa168f5baadef2b9419a09235f68d442672209ed215"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97e3d43a958dbd3e703e1a936c8f9c8f364c99e80b9ec96283696f3a169eb110"
    sha256 cellar: :any_skip_relocation, sonoma:         "070314096b9a84582ce3614756c30431bb7fd35ae4482504930759a38eaf3ccd"
    sha256 cellar: :any_skip_relocation, ventura:        "4122436744dd90f041436abe870749d913f4747becade2d52750bdc10eef02a1"
    sha256 cellar: :any_skip_relocation, monterey:       "3efb2a2aa2e88c6b595ab21566973a261f648524cdadd87f6ccd30b00f2bf74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19238339bcabad1017e5f8ae6b184920d46aa8141883e0789c60c78e15e43380"
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