class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v1.16.0.tar.gz"
  sha256 "ea5618fcf95d556740e95990161b810ce4b021dc82c7ceb90f75c879b25e1c4a"
  license any_of: ["Apache-2.0", "MIT"]

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0ba5ae9e2605ee5642f2d09482ea457edf499204608cf8bb5a326ef91f70bd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bbc76dbbf26df5650b9ed7e0348e668e9aa1705b33aa7d00161343f5f889a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "627abbd34bb7d5ff32001d29a545d43350be24dbc4474751fd5ee7c65eafdbf8"
    sha256 cellar: :any,                 arm64_linux:   "8a1b4ea7b6d90502072f8c27cf4b054e8e9d57eda1287e1a20295bcfc3917601"
    sha256 cellar: :any,                 x86_64_linux:  "0551444ce07084f7fd422dd6488c432ee1fbd596eb368b59fccb109867729e79"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite" => :test

  def install
    # Disable `rendering` feature to avoid building maplibre-native from source.
    features = %w[fonts lambda mbtiles metrics pmtiles postgres sprites styles webui mlt]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "martin", features:)
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