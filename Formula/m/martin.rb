class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v0.20.1.tar.gz"
  sha256 "7528eb1fd89bb0109de48b0b06a30ffca64c243ff60b006c2a8630951a5bfbf5"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb3c254654ffc62fb5e8ff47ce16b8c078eeab7881355bafc277712776300113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72d357e4c0913341f764564658bcaed4c5a36f44b4aef62103a76828d2a15aa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "334491b5edb8c179b76b80c6cdb2820a8d70a95f31a99c71531f701cd65fde65"
    sha256 cellar: :any_skip_relocation, sonoma:        "578eefd5424e20080650bc714e89bb2d3e4d66fa15548e8f583434617d3c1032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cffc3d393a7217ec68e1b36b7942f3fd90add20e158600d227edcf8b0801e717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c2a9b02eda61f0213c4413aafe73761cd906151a559b94a21271c5d8d197e4"
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