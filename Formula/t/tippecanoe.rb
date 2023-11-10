class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.37.0.tar.gz"
  sha256 "6121929e60b6a3ab518cc6248360724cd76e2c814a844655b78233aac954db6a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aae13884230679b64a45a93bef1647ab290b183911a313365258d448aee76ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5711aacf63b9509c7bba8925419e57690f1d4a7a49b0c786464dfd892a127b23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e8682269fbc210e1d27c04877475f7ecd50eac862802bfd2c0d0b398aab50e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab79651ea50404a8b68b1645270c30f1d4578e18db646fe68669269255cd32ed"
    sha256 cellar: :any_skip_relocation, ventura:        "5355e29c8ee506e046792cc8a1a38780cd47ee01c3ddc926f2e2a22b6af01540"
    sha256 cellar: :any_skip_relocation, monterey:       "1e6895acf2574a942ab848aa237adeb651f451393b0429af6d99c460b429bbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b413e824d02af6407f2d05277d7d4dd6c7b030adb3da75457fd337f7963928c0"
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