class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https:github.comaome510spotify-player"
  url "https:github.comaome510spotify-playerarchiverefstagsv0.20.1.tar.gz"
  sha256 "03f0f7a4bdec27f3bd3a068977a0a76051d57b18a715ef8b2966ddd0dbf2f8cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a04c0fd1574990c9aec97fd8277811cef910d600fc4d0944a286bcd8c28d6ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d0a8b1e7c4813d426c622b77f4cb4ad9b1aa259740e242b2f9cfcf7959fa90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71282260d1d8586979cb79ef8e09768cece764f263ea8490522f85e855cc895f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa2747dde032e2bbc65e69ed4c1cb2782d12c14aea2e39ad1fc67f9f8a54cf4"
    sha256 cellar: :any_skip_relocation, ventura:       "e71c64d912ccaf3cd32dc3386919b5a044606a7086068540d3b96c93fc1a1152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c041601fc350ab56541baa4d78fec92cf02d302b298dd2eb4c3267beef2a14e3"
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