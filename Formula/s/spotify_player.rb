class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://ghfast.top/https://github.com/aome510/spotify-player/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "8b4c7ec7855fb2af8862a1ca8818307f2befcb00c02e9e5da570b1a5b3b908c1"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "210045e8f863c7d100461219ed45b1c3b0caba980c5eedf8f542aed5c7641083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf3659ca36c30fb48d77c3ce6aafe7de790a9d8011f5293b142a11d9552e6db6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7004b7e3bbc15dc6b6a561b38b743a3108e54d8a327facaabe4a6b88fb01d39b"
    sha256 cellar: :any_skip_relocation, sonoma:        "86a343468a6f7404ee0f7d83585a9aa32af3e249185fe816b95fe397b2f472ca"
    sha256 cellar: :any_skip_relocation, ventura:       "e000b00a505e7b13dea4ca2f25bce54bb8264a0d015ef6286c737b69f89859f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "700fe9512323c9a1d2b6b8e0960b8a8ff5237d1d4a5dc7c4192590cbd62cf618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ce09c6fba38661139cafe7aeddaf1e3809013f4668232ecc46d18b8d815f7d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "image,notify", *std_cargo_args(path: "spotify_player")
    bin.install "target/release/spotify_player"
  end

  test do
    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "No cached credentials found", stdout.gets("\n")
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")
  end
end