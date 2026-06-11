class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "07123d997da7b9f80c6f00bd11231caa8d8cb057eeb3f0ff916b6f95e713a272"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "839eae10c74c8492db679aa1c6b8d26a04ab62f27319e77b647b6fe395b28945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92968476fc3b240b5327076e0ff981f00be9af99bcf5e20b21ad2ade4aba28f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "943b4c88f184f04cb7a5908876424092437c8ea78de5aa8c3ddcb1d711edea3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b9de3f62ac13229730b0d2a32f5ed1539d315fbb49aac154775846d984bd963"
    sha256 cellar: :any,                 arm64_linux:   "d4da3ce4029f92d94588dfecfb39aaba4e9156f09962ef3c8d2ecc1faf5e0ec7"
    sha256 cellar: :any,                 x86_64_linux:  "28310a953ec7125af5384dba30f1a0a1fd050be1291d5c99aea052dbacfeb48b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    (testpath/"concord").mkpath

    (testpath/"concord/config.toml").write <<~TOML
      [display]
      show_avatars = false

      [voice]
      self_mute = true
    TOML

    (testpath/"concord/keymap.toml").write <<~TOML
      [keymap]
      leader = "space"
      StartComposer = "i"
    TOML

    assert_match "concord config OK", shell_output("#{bin}/concord --check-config")
  end
end