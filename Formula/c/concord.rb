class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "9ee4e215905c47ba6ff3434205d6a9f2c47fb3c7c7ee5a9d4b7ff1851268b2fe"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f152a3438d1fb62420229698a1dd49b66c0962a7bac83ebed84c76a63ac1dcb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6649e91f0ac191d129202b693e1c8977a53dea2950f2413dd0c9bfa6792b5c86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13166a6bc386cfc35291fcaca28eeb25b634c6708bc1c41ab7bded0d84c739ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "238cb0cb2d5ef03535161e2e3b5278f79630b29abcb41a210ac6af3a79b1d3e6"
    sha256 cellar: :any,                 arm64_linux:   "a6df1cf8c03b4d9722f1684a1c1bdd18e3d60b70562451cbc0e4b5f2b5a6b35f"
    sha256 cellar: :any,                 x86_64_linux:  "6741dd9de83bb1a4deb9fb08b0ff0a89a35f73ed1b04c1582402a53d9c3cdd5d"
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