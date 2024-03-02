class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.48.0.tar.gz"
  sha256 "2629bf848f321e92d346925cc46bb1fea6867096e9ca9846e7e463efc207c7ee"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6691d2cd993ca667d0481fa6502e0cc3bc51eea992f89183e622a48c1306ab3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1e8cface129b515053dc169e40cb42d2998a8daeec087122132791b5e082a43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5bb3b478cb9794641a228fa0b6fa3fc3544d394b0444f7b4986d329508cd2e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e25b39d17d62cb2a423933b2af090d257e87a8cc7f21b4e17670ed67b1f0efaa"
    sha256 cellar: :any_skip_relocation, ventura:        "5a7ddd660c7e0cc8b9860390516d40570b79bd70b0a8c23fd478aca4c3a527cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e55fbf9bcd4e36508955159bd31a545834b53b0494c5b2696d449ad5fb8fbc18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5216253e00c7e2ce272d0fd6943c126c0d470f8db44607aa4571c46dc2a4ac60"
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
    safe_system "#{bin}tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end