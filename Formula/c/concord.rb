class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "77b7d6b83d564976927c5184fc22802931697e5f6a041948a1274677c500b637"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "972599ce7d30a84dc3293dfe4710deb24eccb30e3bca9de569152e976bc89ccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02d36d7144a186bd5fc7e7bdce7521ac294d99abca647f07b9dca7beeded5497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a2c6b04e86a0c3c5c175f818d1c74fb1d1dea9392f18b627adb7fa3d747d9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd53bb3006d5e3167eeca666df7a89d422b95406dbbae9c3f84b6b47f4188a9e"
    sha256 cellar: :any,                 arm64_linux:   "e332ef8fc291fa64181da062fe2dc31c17f0130e52605fab0615d8c67d096acc"
    sha256 cellar: :any,                 x86_64_linux:  "57c6600050a68d0b2b0bbf2123c875248cd0f96497c96b94e34710927cc5432a"
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