class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.30.0.tar.gz"
  sha256 "767b3a97b68f4f0127064dcd9711698a37e8245977c0f8e39ef65d1fa3a1e65e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0597b21e7baf62de3e398bf18ab003498a4dc5a81fabaa3773bbba856a1e35a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb6c9d3040483d2f8961075eb12cc23593a28333a634236c6e872dadf196307e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a914a4e2fbef9411fefb559d4d0db27374f4eb4d9ed0f715d7f240dd120beb3a"
    sha256 cellar: :any_skip_relocation, ventura:        "02d5e92a23579a65af36bb014375860526d7f72e928689bb079fb1f994d5d787"
    sha256 cellar: :any_skip_relocation, monterey:       "07e8414c660165cbe115e20f7bb0327069e6859a54e104c544ebb872e9484531"
    sha256 cellar: :any_skip_relocation, big_sur:        "6483e725d229e69e442c752c0b76e3aa22840cb71f789bf2d18a772746fa7453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed27602c385c670dab86f0ac5f32186d4356148aaf5233a86948b2b3e1a97ec4"
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