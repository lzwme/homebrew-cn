class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v1.1.0.tar.gz"
  sha256 "9c1381a47817e85a512f4c4152c03a6819440dbb6c17553e983687ad329b7d64"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dea64f288a86da16c972e5ffd249b3c3b6357332662785f040b29bd0995b570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b0cbe251a30140adcfd8c56b4dcd38c42e78ac4ef5bd0a27a56fc8f56c4e939"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a986cf8ad3260715f0311714a3abf858e2ffe71d419e2afdb8811934ce1b3f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c13a7757bb3d80b44e6f4744b575f9d865259f58be25bdba1d2e8a989c8887c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6347754ca892c2770c3f24e34eb394b23ba2c8c8f2296579b3a595472dcec46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da3793e06cdc0d3f8f953c801925db30258c806eeec1c3410d3e185210a1125"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "martin")
    system "cargo", "install", *std_cargo_args(path: "mbtiles")
    pkgshare.install "tests/fixtures/mbtiles"
  end

  test do
    sqlfile = pkgshare/"mbtiles/world_cities.sql"
    system "sqlite3 world_cities.mbtiles < #{sqlfile}"
    mbtiles = testpath/"world_cities.mbtiles"

    port = free_port
    fork do
      exec bin/"martin", mbtiles, "-l", "127.0.0.1:#{port}"
    end
    sleep 3
    output = shell_output("curl -s 127.0.0.1:#{port}")
    assert_match "Martin server is running.", output

    system bin/"mbtiles", "summary", mbtiles
  end
end