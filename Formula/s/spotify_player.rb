class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https:github.comaome510spotify-player"
  url "https:github.comaome510spotify-playerarchiverefstagsv0.20.3.tar.gz"
  sha256 "4c012dd5c7f0b1aded454fc16414ca20a6a1fadca2757e699e2addb845eb2ba6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3cae5a177e0c4a1f71139a2628869a2acf7e145a4ba7f74d0855267fd372db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e40ddc0f54ea712e2e8a774d66b297ed1f5670b8929efe08f593d005aab6a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "058ffd0034a25c428e56aa727bfff9fcacc5e59edd937bb08ca25cfab9378c8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b1393c9a04b39763cd9c06da04d663e5e139c2d947eaf2f0e5dc4b605ca387f"
    sha256 cellar: :any_skip_relocation, ventura:       "582cfeddd3063db2fc86a5de49eb6ee1e657a49e13fdebeddc3ffa1ed918635e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "124116e0882f92f361a72e62e5c1c16ce52d0d7fe86b4484b44763a2dc20a39b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "image,lyric-finder,notify", *std_cargo_args(path: "spotify_player")
    bin.install "targetreleasespotify_player"
  end

  test do
    cmd = "#{bin}spotify_player -C #{testpath}cache -c #{testpath}config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "No cached credentials found", stdout.gets("\n")
    assert_match version.to_s, shell_output("#{bin}spotify_player --version")
  end
end