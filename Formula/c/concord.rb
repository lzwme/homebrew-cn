class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "9f11fac7b8f66f9ae6ac8e7f43b4718ebc584c4ba138b8d92217975e0288054e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a6435787ab0098dc315786dc6855aaa6fdb20d71e0310fb81227a0383e87522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29a559186acb82e76b4c15a372e098b0a428375eb08dc0300660c3cfe178563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b0c3d01278ba46a750f75c89d889272fdc8dbf2792f2129c635d68a06f8ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0006a35e3d2238f58afb11ec433199f0500ac27eaabc31bb41eaa087c9c66f3e"
    sha256 cellar: :any,                 arm64_linux:   "e61c6b433cf34a1e058fae45e3354722af8ba43e74adcbc1a40e68ba3e5e1df4"
    sha256 cellar: :any,                 x86_64_linux:  "f1923ca7d4548bad929dd7adf2bd5499707c0de29171f514c634dc6bc078e32c"
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