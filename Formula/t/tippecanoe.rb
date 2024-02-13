class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.43.0.tar.gz"
  sha256 "9ae5fcfd9ca89411879163050ac56a5b440e39767834b584a474ee69c84feed3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f5a11b2062d84ac6e7dd204ae324a4bf73fce92984c4ec20e26dce9636d5997"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdb66140af3f6732fc47f43813d03248cec240f5318edd85342d7108479f674e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72672a362d785145bb30e2c8482075fbf2717744b63c5ed5014386bc4ff347da"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7feb25df22416488b10ba6d4ff0d5dd243e32769135d4382e75ad802821489c"
    sha256 cellar: :any_skip_relocation, ventura:        "88bc5f1d86b1776a279fc21c12afc0a4c538864042da411dbb001c1ad329d93b"
    sha256 cellar: :any_skip_relocation, monterey:       "128c3d0391381508121b3b793b5fd7bd2a419102cd33de51e773b2ccb025474b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a534e9104b5ed3515fc2baa2c3f82dc4e1f10ae673811bd3aaf1541840e04035"
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