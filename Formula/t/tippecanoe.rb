class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.57.0.tar.gz"
  sha256 "34d77da8d71b27db4d3ac7ae014f70f0105b8af96b570dee1b9278640b1203ed"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d5397d3a032add1022578a0043b36d6e02f1d6867676de673436a8318e87ee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce465e64a951146f870b333034cbd1bb05a2be6a5d1941d463969e02bfde3935"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd36b11cc102dcfe33afd5482efffb17ac7b1787b03e7b55f970409e49d486f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "eae3f081a9620b7865f2f79b5d331836e774312b06bd5fbd5ba5e40298813812"
    sha256 cellar: :any_skip_relocation, ventura:        "2c29421f30f28577891259fd459b2fc60df10dc66d9c79ce1d31e6bdf7e25175"
    sha256 cellar: :any_skip_relocation, monterey:       "18313f9d716109e1bbf56f3ca02ee428392a820f58d50bc45a2d4a2536b4f57e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b3aab4c60d387bff3f1f8ab8bc2b92cbbe7a94e788c0d50febd3fda1e496f67"
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