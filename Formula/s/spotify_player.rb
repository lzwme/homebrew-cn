class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https:github.comaome510spotify-player"
  url "https:github.comaome510spotify-playerarchiverefstagsv0.17.2.tar.gz"
  sha256 "b694bd12cb6a2a783fcdf21201d348d43c6d0fa609d0405b0a696beec6f89df2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28e80e0006c9ffa32e09e8138dd071e8e75b8d5e7217a7a81f76b2cb1c0c7944"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fd64208f2c815218b8481aa845977d9cb7be0cba3c90341952063a75c777540"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffed338881e0315b47397024b63aa0acc6476f18d296b95bfc214ca27494ae4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "16d80895e166a79d81eff8e72b15d84160128b75e37ef6f67356a5337a22b74e"
    sha256 cellar: :any_skip_relocation, ventura:        "3162248bef8736ab196f0d7fe8e467de3a6ad5120d67374c17fd2dae40763ef4"
    sha256 cellar: :any_skip_relocation, monterey:       "d02929e9a5e1044ddcb5cdc086b859840fc711ff9c0db385a8f9fe8903588146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5427a316ee060e38ac2db50cdf9ee2a648e4091f179120a5fea340f8e0c3aef"
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