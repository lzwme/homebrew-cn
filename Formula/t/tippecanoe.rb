class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://ghproxy.com/https://github.com/felt/tippecanoe/archive/refs/tags/2.33.0.tar.gz"
  sha256 "67f8b3153e22ea9940cc0251fca34e345d9eedca6fdc7f858102e407c0fa09c0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8290646599e4cff138513eb4caac8c96b322904dde8bdad1c03c5e54c0459afb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f63a93af8704183987ea9af085ca92ff525aa4916f2bd9038a2c01cf45e93e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d01cc8d7b0175493c9d314fc83a402b8c063373dff33ffb74904a0de3e9f3431"
    sha256 cellar: :any_skip_relocation, sonoma:         "76f47146eb8775a16767a167164533b3a50047b0a77ad0a6bea25729215e8c17"
    sha256 cellar: :any_skip_relocation, ventura:        "9d8650563d477580fb87c3c9835c78c49df43255c83c67b8cb7ebef1ae00d74b"
    sha256 cellar: :any_skip_relocation, monterey:       "5e72d3f7b416715e846486191461ca4016d821a316b6516c05b80f0ec231a34c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf90a16b08557b9c1803bfaf64ee79bcfd5d1878933cbc049453375a79145b97"
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