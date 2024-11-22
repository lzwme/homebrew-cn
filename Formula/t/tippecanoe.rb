class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.70.1.tar.gz"
  sha256 "c4fe2ecf6bdd31371f1572fd42ec9c2d23da2701e5fbfe5986bb2f4644992a57"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4c02c0b0f3f011650f3f49c0cb04281743aa139b1c6acd3da37218dcc316d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c318e2076a062c752f521fb7019e7aeb376c2d315f282dc38a8fdfbc968f5ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4c201d5e742df1a98119e0ee12fc8502dcb5b1af5e7eae20333a19d168944f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "289c638c8976962f90ee80458878da13118bba9f6fdbf4f0ad6c379910794569"
    sha256 cellar: :any_skip_relocation, ventura:       "229cac9741691e1a22e16bba1078555e6efb8f86afadf52006e8cf31432db61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db78842a89c6b623476eacb49dca75742321733fff83b55051772006eb07a5a4"
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