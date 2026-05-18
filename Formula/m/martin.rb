class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v1.10.0.tar.gz"
  sha256 "e850205203066d6108d00973fdfcd469c76464dcc60c9636c2811ac44c4fbd8d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f40c73d5e3a291cbdea5e05e0192351cc3dc08b3dc53dc7e66e75c4a5bddb713"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499ad1ea2feec1c47d630cfeb0768fc2c78fd257186cabd28f095ec762bbc3f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a0066cc20a67c7b0f77e663394ee840559b884f7f92b7c9fb8083c83798bdf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcbcad1b2e3ca368f6b279c5bf425958ed0f0508073e64f32630e12e4df296b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c52b5cd0f4ff5026dfdd50fd822553e2fb641556ae8ceb6706d14e2e009fffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47232a36d2645ecb0df7ffeb6464c9f1ca02c7250f4548f45a66b638f78d917"
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