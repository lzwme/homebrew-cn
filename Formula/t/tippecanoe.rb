class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.38.0.tar.gz"
  sha256 "2b9a40dbd726e6e8875831f4d60d092d19f8bfa1d0fbf24a3d18d82f50c864fe"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6668e63e380508e9527ec743014643d28fe17cddc2bd1aa534189acca487f4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbce14a38aa285c3ca2730191298665ccf0d5f6c6d5760ac737b938b3fcbb1c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820b536bf78a90dbff543d230bf5709f5107dcf23d852120d5e315a8e3b85c58"
    sha256 cellar: :any_skip_relocation, sonoma:         "08098393b3315efa460fc47ec3e0d39eb11126d07de629b9906b7b5e4f390657"
    sha256 cellar: :any_skip_relocation, ventura:        "05ec66813526307c00910c235c3407471963658cb8d345d678a5c5e9b9fe73f9"
    sha256 cellar: :any_skip_relocation, monterey:       "028ef7dbb1df9c08b926ff0c95c7e36ac010eea234fbd7abee46ec662fc7cafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f8c96ddbca536755c610308302cdaf13be9bcc3c8f70f01cf69f8fe4479f5d"
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