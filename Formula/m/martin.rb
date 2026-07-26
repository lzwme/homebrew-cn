class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v1.13.0.tar.gz"
  sha256 "8c1debcf831f684dcfc0f0e83e2bd56415a944a4b89ed7ff58a7fe93b4d96009"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2dcb7dafa6cc53f1afa452f5b37bd8aa0aad851d12552a55ced6b61843ac8d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e1660057358c7085a902205d3e804d4e8a861eccde1af3dc21a647499a50cdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eca21418236ddd51e62da24cdfb787a09f5407809ba934eceb894c1fa610ec0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d3120d5d2ea492f5ef9ddc9ac7032348eed7cf8af5657518e74b16435f42f60"
    sha256 cellar: :any,                 arm64_linux:   "a709472559e37d9fc1cd58a48f0eb2b3c6c9b036b0f34577051759068b6526cb"
    sha256 cellar: :any,                 x86_64_linux:  "60249687c5d7b3c40949d206d7445a772a30bb3e94f45dd972357dfa5e0faecb"
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