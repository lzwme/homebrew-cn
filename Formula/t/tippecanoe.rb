class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https:github.comfelttippecanoe"
  url "https:github.comfelttippecanoearchiverefstags2.56.0.tar.gz"
  sha256 "6f9192378cd468dd08412ff38f4d4d71dbd7761ab064cf880ff3237bbc4faa40"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2d51c18289c038d5f9b4e78f01d0546d773a68a539dadf88edbd72559f9fd1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc6430d8d62dbe843b52c7a5f818543e0f4e7a776b65095f4f358e5a8ce5390a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52605ed395cff75c62ddc2701241ee2126cad0ed18da4a374f733b71104a24f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe640471f30b3a221c0b51003cdb9d2f45e32026e46fafd55118b108d2f6efa4"
    sha256 cellar: :any_skip_relocation, ventura:        "8df1dc06840ec64cefd0d79fb95431e611e249161cf30b3febb2f637846835c5"
    sha256 cellar: :any_skip_relocation, monterey:       "e6b946298babe812b9b401eacc23ec7002b44d77eaf3e9523dbbb628832dd539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce49357ea28f8bd9bec4e323b1c23245edc962972ca58f62572d6e7762ba129"
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