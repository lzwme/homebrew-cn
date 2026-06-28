class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "2249338feec07860abbe92275fbb58323a0bf5d11b29b8678ca9a6b464f7f40e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66ad2111b702db4d9fcb01d79658a41d6b0196a2481a76f4a95f80563fdc0914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b02434d59a95287f77bfb1572fe715ed2e2a12861d9335527b8c54ed60e2596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb762db0a4e42488bf32864debe81d9bf7b9657965739bc19727e5071d2a389d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a93b8341f1f252922c94fac8ad36af41b4190edcdb30cb16734d13624604b9d6"
    sha256 cellar: :any,                 arm64_linux:   "3e96db0b519ef3ecc1bf47b4d37e943630da2f0b4bf9f6cd1165cec468e19d35"
    sha256 cellar: :any,                 x86_64_linux:  "10dc1e3c72a71f023781f2792f381eb64eac9102e192e86108defba0d1a63155"
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