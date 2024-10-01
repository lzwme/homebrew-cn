class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.62.5.tar.gz"
  sha256 "d1f1f8f94b8127894f93ae7e6c2d84d891d1fdcc34f87aa8628ff14feebc27be"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9666f5aa4071e48a3b2e4837ed8e4f2d7bc32b1b957356b96a1dbc6bcb104d36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac5f2fc85a1400d69d51cf6415da4038991a7f72eacfdad76416dc332be969e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e29ecf757144b87d7d3f40674234cdd729618d2c4fabb214bff038f277d5316e"
    sha256 cellar: :any_skip_relocation, sonoma:        "de54931b484478e1a0e254984e6c258b381a61ae28c4f04238edf92c6ffea421"
    sha256 cellar: :any_skip_relocation, ventura:       "2426444eb0483e222ecc1498c621fb163b031328854064835b0025be5c4cbbfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a81dab1609155d3a72963c79d8e94693a105d276d21f0b89bf01170aed4c2d9"
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