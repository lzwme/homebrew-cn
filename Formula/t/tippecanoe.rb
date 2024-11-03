class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.66.0.tar.gz"
  sha256 "63750f260631c87f1c648ab201a03516721ed98e59ad8e92fc65a9e3f9f9f4b6"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ea140e2fb046328d155688531d2d24b47e18cffe24dccb18b89c0d0baa5839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72a99de8a54e1ccdc8b5a0811a285b4f7e64fd6b2e63c19ad33c1e832118e352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "258d40e0940a2603a4b11b6110067fd762b02fa5cebf35e0879aedd97ea87830"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f7535e1d0e5b1c207b640096485e3b5714e97f943281be4795dd16764c6352d"
    sha256 cellar: :any_skip_relocation, ventura:       "86f3ffc2f05c4e764fce113b4cb9755ecc06e23486061724e2bc9c6b75f34b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642913c430d937031ce7f5faa2c3c427c623bafb82f82a1ec33d58ee6d3f933c"
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