class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://ghproxy.com/https://github.com/aome510/spotify-player/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "2f70cd8fbea928022497fdd34140ce648ff695cdcc21d366228f41727c9e0d1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55295b531097732de49e81a4f766697888601c3c789dc95f97f690d8e2d445c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdd3042c9e5033839b2a8fc5be01e477640a106675c57ed34da8642d7938d6f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cbeb0f5207bf47bf10f571ea42cbb8a4801697ec8513b6483202287e1673f4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d57b2dbcefd039309e9cb3d3028267514646cb57f925b8571f1049c7f667736c"
    sha256 cellar: :any_skip_relocation, ventura:        "92b8f8310771255a3df5fc08163872bd85fb0b5302f3eed911d220ae5e1b8389"
    sha256 cellar: :any_skip_relocation, monterey:       "1b993e1831e71a94e95022526ee5700774c1302964170757254a711501614b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a01016c450b62ef5f98b367a08866c455967b82259c8c57ee67ddb5f599864b"
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
    bin.install "target/release/spotify_player"
  end

  test do
    (testpath/"command.exp").write <<~EOS
      spawn #{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config
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

    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")
  end
end