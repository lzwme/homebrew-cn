class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.58.0.tar.gz"
  sha256 "bfa8e2ad4bfd552c42d324765c9684efa72a1750807ffb9f03a8b9b7b01ca866"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47c6520e51738868876a586ae5c63e8512db00c17a0de9f24c00ba41e8b2ea76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8845fc216ce9a6e3cf034a607eca223376126640b6abbbda45ad1402cf5ebb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dee478a7fa994f6512b9d58fec7e68559bfcf66ae02d7af5ac24828b2e6ee13"
    sha256 cellar: :any_skip_relocation, sonoma:         "f843698fb0fd337e6ebeaf1cc27a9ffbcce1bf739e1fc28b3627bb5015809577"
    sha256 cellar: :any_skip_relocation, ventura:        "cf2237eeac702ab9fa21140c74c8636b07cd5e2576c4504112422f9712147c62"
    sha256 cellar: :any_skip_relocation, monterey:       "856c9268c4a880b58b0678a66bd48ac84265997f635a0d98b2690ec4635a8cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86358e0b774d6e34a04fdb03a4e5c852c11f7c522fb802341e94b3133dd0c9e5"
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