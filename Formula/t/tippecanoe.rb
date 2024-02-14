class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.44.0.tar.gz"
  sha256 "50ec265736af21d5341d808355355f1c462ebb336d4400f8d2a4eae4a3309828"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "036a1dddbfdf4a10527e65772ab4ddc2a64808b40d3291b4953f0c6b1928d0b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af644a1e15b8562d595331deeaf047f0a02f01eb088d3c311b2024163cc3cde0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209d875688dc0ce8bb13584b6f221b7e3138eaf5818f06decdf18cf8c9cf3899"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c1261525be7aad0d12472be4c81b3f2385289cd474b7ee7dc239eed930e42eb"
    sha256 cellar: :any_skip_relocation, ventura:        "1ddef9f50f11db416655d5e26eba148e216267fa98183d351ed743a156710b14"
    sha256 cellar: :any_skip_relocation, monterey:       "7dec177254ed6481a1d881307af06a77db39ce6763e4a6b1a6b0a1cb033217be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7df5467e0b4ad360d3cd31ea2da8a0c71d58e85ca0a263116ae558a1350ce9e"
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