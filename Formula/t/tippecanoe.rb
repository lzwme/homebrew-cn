class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.62.1.tar.gz"
  sha256 "89f69dec3cdaff6b76466f360abed7291adad2d08da7e41c510f0ece38b28e07"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a3b7a937a05c2e5c427b50e7b34f75d78a80640e6a51fe1019bc971b8765337"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0f4a10661596f82bbeb936b457de43dd98c99d3bb087fe422ffac3ed240f9df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fcbed931da11b16ae58ea2aa2da5ea865eb11de3d596bd63d11bb8c3db77c47"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2a24ed618852a210b75cc674d4b51535f1f065a0c23262c038a97ef529612e2"
    sha256 cellar: :any_skip_relocation, ventura:        "67fff0330e8aafbcc576b7773af6c5e0723cc16257cb5dd99444394fc1613912"
    sha256 cellar: :any_skip_relocation, monterey:       "571492ffdf777393173328e2e7917117edb3534abf621e597c2d661ef545ca0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a6e947f41c77a9054c1dd322c81c38383f3ef496e68345e6067723e4bc63c1f"
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