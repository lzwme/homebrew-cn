class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.28.0.tar.gz"
  sha256 "a5454bb1f281e69e347d4beb77982c9ae4eff5a3162347cf017149afa19f703e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc3cb9f74472a38e59d91b33bc4f59d752fa28ad7d100be9c50661507f1eec45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "657d2c7fad9221c2f2a1728d6f041a703b35c85d9b46eda78c9d7306f2162c63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82cb230cacf513477a7ec45f8cbbe29ef9ec6a028573dc96805f1ceb52984cfc"
    sha256 cellar: :any_skip_relocation, ventura:        "f868ffa25960905e8646dee1f5dc3a6a0e80920b7c16eb16edb3ed26b3e3adb9"
    sha256 cellar: :any_skip_relocation, monterey:       "f9a5204d2abb7ec389b6396d76f1a5e2ac298b4dfb6a0c54710ce3f3bd3963c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f35a7e2693465d88b183c2e6b887e80eff90a11017af08e913f746ccb53bfbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2935857cd308965a588e0ea36e3e022b4101b39e6241f0d095877b21b9fb8ab6"
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