class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "24bbf2b2c725795387ee5bcc2fb5a49aafb2df58f79fe793ede5ed47eaf243ad"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4df80c7301cb238ea5c2859f1f98a370d5ce7c473782436617ca914f69bd1eea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d0c7af33ee554a019f38c8cac22efc2a058e07086a1c90cde43088294905978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "373829f84376b0d7548d791e0237c8e62ca27bd4fafaefc50f17515b36be1cb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "36b853c60ad2a500dcb375d7783bf52d56a291b773f01ab1509cbc0ca9ca8246"
    sha256 cellar: :any,                 arm64_linux:   "cac56c0437893e9f241ea3f0bec77a2bb182f40a8d1b4e5fdd8002412319323f"
    sha256 cellar: :any,                 x86_64_linux:  "85439ef7c563b4c93e011fc054e6bb4112a5b9fb3026769ebe323d0fc651dce3"
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