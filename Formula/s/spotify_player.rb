class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https:github.comaome510spotify-player"
  url "https:github.comaome510spotify-playerarchiverefstagsv0.20.0.tar.gz"
  sha256 "a0708da71e30c0d213bb9f840fad4e3667ce4348d4a9dcdd6370d00b9ac2bda3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2a250500afcb2b48272232ce33a78f2658b1bd40237637ed9cd80b05bbba16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae0d7841d13499426d9ad5983fd0a5fca450630b0e582db1162070254f155ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7171536db6580037b3806119cfe255303e4bcfe15c66d20e81db0db84d84e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac086bc837a7fbf5ed6e523a3754ca4b2b30c75f7e977a79125d1a3876b90e19"
    sha256 cellar: :any_skip_relocation, ventura:       "ecc13bf53831bf708fc340c9dc4b8cd1646442d6f19898ea32e9492658961034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e6caa7b76a29776f9696ffd0c6171fabf19ceb1f65991d55b7bce92e2fd4b0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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