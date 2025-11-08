class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v0.20.2.tar.gz"
  sha256 "2dccfb9168c1bf2a44dc78962c6bc8ff7fff373d973dc978c80f4236e214ac73"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b2381f57f4ef465629199a0e32bf8ec977f2ae540a3a3b418e07a946be85cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8cae8700c60f0ba96a4c2057ee034826b43cb9453c4c818c613e6d4515ad49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74516a00d0fb1e11bc1f1dc06df6c29edc6f05ddf9e0facc6b066c05ffb5a0fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "eac5a3d10fcb77121951723cbc4ac7705b90b0fd577dcc2988ecee2d1dca07cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8b5ed564e127767360a25dbb2b52ec1b080b92ce89dc1c0b62889b75ec29305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36099d0951b7cbaf6123e437e66fd81f111d9df8fdbcbf6cf2501f418a84fc52"
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