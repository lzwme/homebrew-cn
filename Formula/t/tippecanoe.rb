class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.60.0.tar.gz"
  sha256 "ed5722674ba90e5e7fecdeabb671dac0ee81fc89c5f3da35cef6b50300f4ba4b"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8d1ebeadb91159d144828477ed7a8bc88447b9e65b1ad185f9178b9c1b2ddee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "641d984d6f6a8270375136e8b391fd8496f32f79e1c8ed866961ce903a698d51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "256b156bff367563636e4c19c809c90c78edea7b0774cf9551219e0bc00e7188"
    sha256 cellar: :any_skip_relocation, sonoma:         "d17567eca6f8743f1edb9151ea47127eb218c063eb2b081e25819e606bf0f287"
    sha256 cellar: :any_skip_relocation, ventura:        "7414252ab37e6c80633bd161c9c293e04c285c03ed564e8829e775572f9407e2"
    sha256 cellar: :any_skip_relocation, monterey:       "988021a610dc47c80a2713e1fcaf1a5b6f2ca81a3ac0fb7f3d3c7be51a04ca58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50c67ffdf068795e317c1e4d0b0f23d805228560a947be617586ae1701def623"
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