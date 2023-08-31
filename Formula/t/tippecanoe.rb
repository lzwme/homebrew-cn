class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.30.1.tar.gz"
  sha256 "03b301c341cae2f62da634d0e0af222abd3a6164309cd4782507448cc1e90187"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a32388492d7cf5bcf0c5d42937c376c42425af45ec2f4f26a3b3b3ce0b3ed7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "222cb041b7f6a9d2472a109463be1e4793ab83db61c13077b584ca70cc729683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c77dc4b1f524ecc6f96505452dc1e88fd5d3ce05bdd4ee5045fd053b8707ab56"
    sha256 cellar: :any_skip_relocation, ventura:        "9a829ddd6f364b5555c1fd3b30a6322bc698d8e826a5cfd13bc20c81a61babab"
    sha256 cellar: :any_skip_relocation, monterey:       "b0c80e6f81b9bd47202380c387588c0e7c4d770a8eb373d852be390c02007ca1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb047a2bce701ec16370817a0ce55317dbcf89cd83070e97f3a23b2cbe667483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f48046a5b2202780480a00148d0c66a3d24e6fd3d2492a13fe779e9d8a5c3feb"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end