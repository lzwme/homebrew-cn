class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v1.3.0.tar.gz"
  sha256 "a536a267fbbf6b7a02574c8db1c0169089c80e967eda87486f005756546ee53a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ab85d6bd8cd29a9cd2c3b73c1e5522e27554f431f7b5ca2b868e1197daab0af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2817d60302de7cbb4b1798cc8b4a61c40263a8cf6319a2590719dbe2c69d192b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256cc52e5aac142f5619a26551d15aa60942ea83b85736ae6d53285326ee4207"
    sha256 cellar: :any_skip_relocation, sonoma:        "02249bb58bc0dc19ac58e8f01c8d634d2d3f393c95127b71c7cc981659a7e604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75c343880405edd6f2d2e59bd05061bb9106a0110fb55fec79728109fb18f06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "477e6e51e2c0e71952d06a1effade8eb29b341f0461abfece9b3cf9257983d21"
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
    mbtiles = testpath/"world_cities.mbtiles"
    system "sqlite3 #{mbtiles} < #{sqlfile}"

    port = free_port
    spawn bin/"martin", mbtiles, "-l", "127.0.0.1:#{port}"
    sleep 3
    output = shell_output("curl -s 127.0.0.1:#{port}")
    assert_match "Martin server is running.", output

    system bin/"mbtiles", "summary", mbtiles
  end
end