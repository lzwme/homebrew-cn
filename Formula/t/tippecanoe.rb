class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.69.0.tar.gz"
  sha256 "eb907f315073bf2ca091e074be4f39b42be02d8468fb31a06744b8766d21b149"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afed6f006ed582aefbe14efcda079392194ca45c824646ab6f41b5b64ae28a72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34421c6062a9a5784aede92a36592bf5299dd1fc2de8844df1aa55cb7d592ff6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28e3813cdb96f81d1ce6e2aad147321948b542feaddeac84c9f8631957a6e551"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a52d6c170538bd8125c7f84817b1da990f7d76df4b6592d9204c93aeea871d8"
    sha256 cellar: :any_skip_relocation, ventura:       "19d3ee67a517e5e7dc450bf79ee0bbb2b38e4f00d07b25edf73172a4c1611981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c250d3824dd572f84eb5a43b51e020d49d51680445e6200a74c84b97288dfa"
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