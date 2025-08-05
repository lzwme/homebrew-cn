class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://ghfast.top/https://github.com/maplibre/martin/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "a89abb35875e3de4ba4134926331c81589cf3b037956af89670012f98788b1ce"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95e554e135320cfe1016ddab8ea251656cfcd0d4a902e5a89cffb0d1f208710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb23383520361a8eb80481e46b0b8da751ddd19ba86539f0bf1422800121b49c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d046ee252744278435b44ea6a34885a8f90fa94b50750c04ba31f5018ac6a2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c25596e1fc21803a76962e8b9c26b5915438878ae2068b1c02e6062bb13d551"
    sha256 cellar: :any_skip_relocation, ventura:       "40cbda15c63b6368f7de2fbc3479b8d515fc56711474c6d2fb708c1dc8c5fbcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbb78a3345e6c05ca1e78322f79ed8229da854d3658609ca66df0ab63f7dfb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b706f1df58d520067118c26ab98fdddac8d1ec698059c81b0eeeb58abc85dece"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "martin")
    system "cargo", "install", *std_cargo_args(path: "mbtiles")
    pkgshare.install "tests/fixtures/mbtiles"
  end

  test do
    mbtiles = pkgshare/"mbtiles/world_cities.mbtiles"
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