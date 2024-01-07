class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.40.0.tar.gz"
  sha256 "71a322e39974d4b95eeaac355594af1107f6c3c59c1199f53fdcbb6c7d90489f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43dc386849ae8b90958235edd5a3dbd63dce408105953d12832f8736f5b46559"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4914f6d0464b77c43b0b2520b2f012b112efe1b489952692af8b99f726bfaeb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207ba28009d5e73cbe865d0f331e78e2307d55e4fa9a08f4569329d03db8bb74"
    sha256 cellar: :any_skip_relocation, sonoma:         "a09cccf61f8dfa74a65fb811486e60a4a14b74e24c44b37f0695547392f3f31e"
    sha256 cellar: :any_skip_relocation, ventura:        "0ade0782535935b5ac754ad9c767c2053b10e731399aa73a4ffef1af58273419"
    sha256 cellar: :any_skip_relocation, monterey:       "db8498f41ceea4a90b04b0ea8d4162cc1bf6a280d129bff06f14bd5aa602ce0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acbb624203a226e9c1f4b091134eeec6e348bb1bbdd83dc23afa57d103314069"
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