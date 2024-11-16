class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.70.0.tar.gz"
  sha256 "a7b34d1f736e6542b08b2a56f0375fb07adbd5cfe0ef273978d1d5272e2ce170"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc6c3f1f8b359bc1a5966e4b0591dd88531f0fa0cae4847acb907dd6fbd44a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec78f2ed16a1433263e3a312e3ed877050b100ec846db1d2f07acc22975a8942"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9751056dc45762d3a3ab928cbc810521be2759a584f72d6518210bc7dad227ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "79e6437c22e1bca5cbe2cbf7ce87fc9dbecc1bee3b0327817ef294f32076bdef"
    sha256 cellar: :any_skip_relocation, ventura:       "ab21f37cbe5ff8f38da9492ca1d9d35c8d1bcb266b7096a48a25b8db09419a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "721f88449ac37d55599d2c786aa9580b65e0108e2e70f47c301ed25502d5f174"
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