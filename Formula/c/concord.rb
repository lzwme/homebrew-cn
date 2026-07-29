class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.4.8.tar.gz"
  sha256 "3810ac49ac4a1f6a6f5da83b955bff950c1966329623e4c075915c4c4559b1e4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a70e67ad165ae20d14db7b5dff728fd4e84daf0fd6954b6a8d88bc725e7dc097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35aaf6d0af95394344a8a9c9cfcda4f9adb9b181ccee0eab9d053175f2aa4061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab0f313495629bab3f52df5d1d95abfd880fa05db5239434f3ef00d7f0f3c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "807de7a883000f8740044ba5bd63276049f36a71c877834e0c20fc673edec1b1"
    sha256 cellar: :any,                 arm64_linux:   "6d6b0e3e14be944e923b592ab7d031f7413b35a37d4fe4e7a08b12e1b3112d52"
    sha256 cellar: :any,                 x86_64_linux:  "e87d0b2d54ce6ddcc5361b413802fadfc5b1425f3ee7cf6e845233094fbea725"
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