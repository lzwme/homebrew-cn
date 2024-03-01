class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.47.0.tar.gz"
  sha256 "55f7386da6b04278e10fec780a36649d91d508494136cb5662f86b37517f3720"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d5436b7a978a0cc397da9004d08c3023b5bd4f36dad664e64d9dd36328ef6ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "568720aac3e155b44b3dc90bec3053543519389a8e2f4ac8d9a2e024eb259733"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "318e3df02064b909a36c22a0c7660fcd116344507c558cd510d43b98a62d884c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fa8b0b31f893c276a9d88c12285eb9dd0a4787bdc6f9e90e9a3e40a4f248fa0"
    sha256 cellar: :any_skip_relocation, ventura:        "ce8e53c82ad16f33bc46767513409ee9e7b559c1f133cd668d94e05c17c82a55"
    sha256 cellar: :any_skip_relocation, monterey:       "eb70bb23019dda70d1feeb9dcbed41bd2f725b18aa4b946813fe1e16cd32941e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d9c127d0a18ec0222ae9695f7f1e09b6657a284e1391f3326160f216a8a4f57"
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