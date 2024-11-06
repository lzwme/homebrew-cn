class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.67.0.tar.gz"
  sha256 "4544f7ca0be0f7ee6852fc3ed03867df7a80dd9327349d3f4c96417112aa2490"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a0fe07547543f376b77145a7f0ac428ae3d2e0b8e985d97484624ab4b54ce22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8d6239c6803f4270222ff8fe45da4c0cf428491ac569f0cc1e391844a2fba4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6867cadd78115966d721f705bb916a0fe7d48ab25681e352e91104eaa1b0aea"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d8a5d3770a6c0db502f572f5b1ba61e6772b377c71174ab386b05eca5c2e41e"
    sha256 cellar: :any_skip_relocation, ventura:       "f50470c6a3135493b984651c185acb6320c0738cfc4ae8e0eb86e0b0e4482ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a6ad3db043599778022da6e5e0a41da6b5360875ce9c65eb7070c16a26d0e70"
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