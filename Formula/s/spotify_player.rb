class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://ghfast.top/https://github.com/aome510/spotify-player/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "d1f27fcbff28890800bc8e8fa4d15cb12d70448d1486f4a56dc86e06c1525629"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36b6739bcbc62638868b44e71926e7719cc07fbb835bf60af29162ce86435c9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00d675c94d1ec41030305fc4879abc3766bc4414e67029b01dde0b880f7f6aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "640f3238f9b8e2e5ee61baf323f29f19d72de4f1fee6419dd44f635a045c7e21"
    sha256 cellar: :any,                 arm64_linux:   "b960cac744e77955d64788376b45935f7f226ba3c95d3d3bef1e08a0d951ac93"
    sha256 cellar: :any,                 x86_64_linux:  "c2d64c8a93f3d1b5506c5d6e4bc99bd7ade5e2b6786f87507934f9208501f04b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  deny_network_access! :test

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    features = ["image", "notify"]
    system "cargo", "install", *std_cargo_args(path: "spotify_player", features:)
    bin.install "target/release/spotify_player"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")

    assert_match "complete -F _spotify_player", shell_output("#{bin}/spotify_player generate bash")

    (testpath/"config/app.toml").write "client_id = 123\n"
    output = shell_output("#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1", 1)
    assert_match "invalid type: integer `123`, expected a string", output
  end
end