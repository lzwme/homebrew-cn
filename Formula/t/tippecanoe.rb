class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.68.0.tar.gz"
  sha256 "088aa4abd723cd6f509873e31bd22d1f6391db92cf7d0c5d4eea1093266161c3"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "076d02065c6affd1a4a61037bbd7657562d9c656da41099c84ae8bc91b90cfa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e21f1d1939b056912ed9d5f23ca337a5bd52dbb86600e6ef5fdf8cf0d04385"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a726f1ecc18b8f82f729c607282a61ea48452d94717f61800db7b1616496367"
    sha256 cellar: :any_skip_relocation, sonoma:        "14e3924560cebf27c1adcce4139cbd3fd0b0c8e131a19d55daea35aa81a436b0"
    sha256 cellar: :any_skip_relocation, ventura:       "2750624e8113a57031602d1bb15cee0f6d13ca9a010e8424d2751cb05ea36358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fafe7dbd674c7744d909ea0286a774cf9c728c54836334ccfd2b0b71d64ccfc2"
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