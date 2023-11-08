class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.36.0.tar.gz"
  sha256 "1127ce8058744b485b7190bede295e30a2c76f526d3855be3f9f3468c6b9125f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fca3571da3955832bcbce1fb2c1cc86cb786f6257f1f3219d8a6589ed0afa52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50a47cddb8968520189f59e1d079ea40263182f57229ff006ee23b3c967cd2d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceb3221074f07d15d034bdf35f4312fce38d4464f62cf79beeb123bd37a7f379"
    sha256 cellar: :any_skip_relocation, sonoma:         "22bc9c3db5326a8f769d208a1822c1c8cadb44558210b00c9b296b82b157f32f"
    sha256 cellar: :any_skip_relocation, ventura:        "782eaf253bc4300b34079ae1275a4915acc3eba0d1bdb8190bf039d7e46bc3d4"
    sha256 cellar: :any_skip_relocation, monterey:       "e168a8ee9ac76dedeb759614361d85df48859d4f6bed422fba447eb39b72a060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb018c2768b48d92d4be8f2bb7038f4bc6b58942e831cc45bbb28f5e52af0e21"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end