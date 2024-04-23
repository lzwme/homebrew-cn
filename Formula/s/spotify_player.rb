class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https:github.comaome510spotify-player"
  url "https:github.comaome510spotify-playerarchiverefstagsv0.18.0.tar.gz"
  sha256 "2e9497e0db320912c87a66298b755487690d78e4fd58c82347d76bd0ca799ac0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d68c2fe0c57aa7e805d8084e6c49a999de5b2b1399ad463c50bb03c1ae339473"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92171fc75586f0576ba4352fd8bb3bfc831b77a9ae69fd4c8b4aa4f7341fcec4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c31b1d961f8275e580c07c48e33b02ff90a92f38241c42276efc372434886571"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bc8e613df7566f27a8e7692071e5dc222b92ff1ae1837a5e121391e9a463173"
    sha256 cellar: :any_skip_relocation, ventura:        "d34f21b21b7a665aaa467540b0db4c09e69a478f0fe92506de30a1a6944a4f05"
    sha256 cellar: :any_skip_relocation, monterey:       "2a0b916e3bdf4634125c88d8d2c0b260ee10c461503d88bb97a74173327198ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41f0ab439c059d178460e43a1890b2b2c18bb2f5a0ea76924c11ec99585c541d"
  end

  depends_on "rust" => :build
  uses_from_macos "expect" => :test

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
    (testpath"command.exp").write <<~EOS
      spawn #{bin}spotify_player -C #{testpath}cache -c #{testpath}config
      expect {
        "Username:" { send "username\n" }
        default { exit 1 }
      }
      expect {
        "Password for username:" { send "password\n" }
        default { exit 1 }
      }
      expect {
        "Failed to authenticate" { exit 0 }
        default { exit 1 }
      }
      exit 1
    EOS

    system "expect", "-f", "command.exp"

    assert_match version.to_s, shell_output("#{bin}spotify_player --version")
  end
end