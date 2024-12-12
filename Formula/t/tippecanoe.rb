class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.73.0.tar.gz"
  sha256 "cf28515e304bbbe65cfc06d3395493b78f16fdbd4aa35bda45cda4cffe54b830"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc66ebcc23cfa97a50da85edd96a851a3f8cc5ef35b4385e2d973940025705ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19f3b4474f52b98d70069c1d1422d8e5c634c269f7f418781202e66f136c9cd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dc30ffb0badea9a1d5fb2a730f341fd46640d0bba5f91561d399e137b165000"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f1c1c3a0c1705ba40ee060cc29518217611c839464f6c99b42d9ccca0101fcc"
    sha256 cellar: :any_skip_relocation, ventura:       "badb096a0c245a090df05f93d10f94f2cfbe8a4103de64fcb6224b6d51ac26f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3291ff2cbcb071ec551acf221c9ee7119994d3367a51aada2e33eaa9981c2817"
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