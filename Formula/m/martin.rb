class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v1.9.1.tar.gz"
  sha256 "7a4056a6735b8f8019ae247060a0a1bef1e9f59fc192d802a6f538b3cc93f58f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1aa71728a366249314d410001cfdffa70073cdce28b344a61eeeffb1ec67580"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19e85363e2559ffccde55fa98b19ddc3e864c22a1e3f35de6dbe9c39be0f3e98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cbe2449093289be11c3638dda93953349cb44866ab73fb647a3c08ed1f29081"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a0d4650da49862ab8f137e067a24cc133d76689a2abaf50d9d38edbd42dca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1a3f0093468fb83b41b2d30b0255fda9c475a0b09180267f2961fa76e1b2d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16fd85b62a340bbc24f0da611dc3148e2505dff3ef801889a6ffff1816828702"
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