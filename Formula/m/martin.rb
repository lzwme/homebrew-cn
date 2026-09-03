class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/martin-v1.15.0.tar.gz"
  sha256 "70580ccd758f4f6c7742463d5e3718f0cb58bd89354bfc65b0c76a53a54f1aae"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb16de0544a04f70243350dedc48123e853f2beebeec4168ab8785b8470f91c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7a43b59b3b6630556b3f59d4dfb5a2074cd0bd8e7c5faaf3dd4108822cc541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9bf12c1029bb00fb7e0a786998f1061f453ea862dc8f0e77f61367cc78aca58"
    sha256 cellar: :any,                 arm64_linux:   "0bbaaeb6171813b1afb097ae446a743d83ea563fc1558163c5fc2d5abca1ba8d"
    sha256 cellar: :any,                 x86_64_linux:  "2eb9705429032fb600ea181497627b3c8460983dd18ad9a53b7e24f4743c0d32"
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