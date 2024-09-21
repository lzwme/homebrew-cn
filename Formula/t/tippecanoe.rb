class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.62.3.tar.gz"
  sha256 "d104da1615d48581a01a3d5b89cf13cc3a72553e03b1967401ed3969d769603e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785989745d373360972afc4d12c7182cbe38936e33802dacccceaf0f88e1f943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84dbfffe2cbe5709bec963d054f1d11e9b93b15e200c815b9acedba7ecba0206"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7a84e735fb75c88a486bb70c534a2978bb600e7f0524fec6c7f29b673529f08"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1585c16091bffda80f27993246809b89fce5a4acae3a015a05da741e501f59"
    sha256 cellar: :any_skip_relocation, ventura:       "f368f85508832e8bc6f6635ee073f4b7fe9868ecf392f863c78c0ca0e8d61560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175897c291ac2873a04302291fbda62d772332749d9732c42459723bfe4d684e"
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