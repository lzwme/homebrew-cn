class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.1.13.tar.gz"
  sha256 "7a2f0deaeb39220a2f5bf9d2e7deda9cdd17c37ee04cb410eb0ae22183a60209"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60760cbf5834f871f39d6f3f578c94e4cece86beae2a0e9d44500374b10bc2a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a09f9afbb6789834d506ba3b08dae8b139ff369170c4caf4524923f42c6664ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c226a812b40484351549c3f01d6c9160cb4933e30c55d76619a3b6c3d18f90e"
    sha256 cellar: :any_skip_relocation, sonoma:        "afe1a2be3e92e8c0a9611123d6a67e50a7b376c8b5fa6185827e289dc5f0e70d"
    sha256 cellar: :any,                 arm64_linux:   "994b98d40d8a53e69ef1db1c6c2dfaaa0108ad91cb292e57f551284f393b22a4"
    sha256 cellar: :any,                 x86_64_linux:  "3bfff58fdc5e36c89ee8fec02b98c640dc07dd8a0b6b3ab6fa606ea9c94125fa"
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