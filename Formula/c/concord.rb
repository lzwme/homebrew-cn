class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "06d2a843029703178fb808bd1e7a6070bcaab2b7d9bedfdd0acc786ca3da4e0b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdbeba7b22fee19d90119b06473c787c2a9cc53c32221caca3a82681cc29ca97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c94acc5f5724807650762eb34f5b7765139a5ea88214fd1a6c7af7cc702a38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "716c4ddb0416f2f1fc34b31c6a57ba18f8ee35ef35b50cc3a83ec5de81bab348"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8ad288eb0fcfe1def82ce9bda1de074497bfb43505a48c2922f5fe30c1567ef"
    sha256 cellar: :any,                 arm64_linux:   "3cc93f2f3b2a946e45d0573aefb428d10386bce30a0ac03faaccb437b08a9711"
    sha256 cellar: :any,                 x86_64_linux:  "f13afc3fc89c597f6174d8a7ba104dc23e07224effe6b9930d6bb2ea4503c167"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "pipewire"
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