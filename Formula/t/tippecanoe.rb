class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.41.2.tar.gz"
  sha256 "b534c2fad4eaa91d52a109a044d88dbfe5cd11f0020c6719a55e84f50750543d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d6884755e196a926fe7244bb24a89f172fdc9f4a5f0649bc2d003b227c273a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ccd6211f90b62f4d893c7f998aa6fce170ccfcbf1acc7d51986e78ab9cdb2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe478ccac6fbf71f3cf9b6542133b973d98527b1c2b24b514beae68b98cbc909"
    sha256 cellar: :any_skip_relocation, sonoma:         "8748e77749d0f0774f2558984bb1bec1d72801d824c95cd524f199c96f05e1c8"
    sha256 cellar: :any_skip_relocation, ventura:        "b69ab5687d1ad4dce793d1f72fc061f9e593916bf55f7181fb575078b34839c0"
    sha256 cellar: :any_skip_relocation, monterey:       "0253c574016c4c90880b19ad2a233e17457a99aae906d2ede729ad6b7799d1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee5ff3774a5714450094809057075379b5efabc38d14a4f4339ca18e7811dfc"
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