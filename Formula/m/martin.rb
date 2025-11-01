class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v0.20.0.tar.gz"
  sha256 "1dca1c1df3fb4966deec7b2c64931c576b1dcda57ef86c8cba7082bac4d1122d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1098e34d82745d350e5581aec9094d062b96c1bec3b47fbc3e9a1d1cfd0be562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "490658b219cfdcb120cf6938d805c5c8ef8c80edc8b631fd6d29fefd9cbc2eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ad0ce1f0917be5a39d4469ac32fc52401f50c91186befe051422b47b499ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "08e9c3c9df2a36933881431d6eecd83f83b77690654cdda083d8b0682a005400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d730112bf69a5f75fc728d6a8aa2b099fb5f2885642da93e7ee9a295facb19b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c64f48e867c5f76c95a40aa3db5ae07da0addc9750938597afdff6182e74674"
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