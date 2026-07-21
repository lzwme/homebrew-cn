class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "d57515ee15d946589df1d9b3f58126552806bf228a6a9d017d2d07f4f91aa52d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcbca660dea30b8db50f23b2f3ecfdbbb6dcec7b0854589296fd415bc11511d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc849f6303c550bbca5c3176ec61d824716a02bc19dad9982321fc784bc8eb0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6991faeafe5964abadf159e9df6fdb9131a4e9d4b3fe4c0ce95ef0b7822ca531"
    sha256 cellar: :any_skip_relocation, sonoma:        "53f057e13717b101e7ccb41562771754a11c7e364b65500b38c3babba221ab93"
    sha256 cellar: :any,                 arm64_linux:   "9cbca8d87ac4fb7d7105e5b4334e898de761299786c4669d7f966ebd60922ac1"
    sha256 cellar: :any,                 x86_64_linux:  "3e4b79fe64c78aad0053d2048041360e1c41ad8fea0022cbb6f4cb81b2218a51"
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