class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.71.0.tar.gz"
  sha256 "593e563573d4aba4b79f89514c2b79acb492f00c4b212e5d4bd06fe071e14c6e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2395b11157b8f1efdce1e2f03e3e1a869e3dfb22483a3dd9426dc26eb5c5049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a9beb586da76101ca20cf31c2b3006960a578e02b943be254dffbcec0e16d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85b332be15bb64f4907cdf00e7a228af4e669917f4b1d31fce4d92dd982477d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "01b9d76ea8bdb85dc9a3c6b683600ddb9b6399197d1d4f25d1133a1bad27a977"
    sha256 cellar: :any_skip_relocation, ventura:       "4744a696fcd6009ab25825dca3d33728a96d92b052d747e497191554413b9625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd9d943dd9ce63b2841b89fe49068909e4633424c26139b897c96aca0fe94972"
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