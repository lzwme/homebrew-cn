class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "1e5df2950a1af9fdf88e29f8159b885ba36e51a63a2a8b3685f284b777824838"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c26ad3eb32943e44e591dcfd49875ba48ea1420fdac4e9184c464fcb7cf5dcde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee7470f4d4f4f7f87f8c39d637f620ece6d76d5be59257fc57b9bfdf316484c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86efa01ccd107c748fde7a0292c4b061e5f9ca35da82ff53fa6c612fe342b25c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff05114649a925b8716dea878b012157fa708569294709ee364ff9dab3d3f63a"
    sha256 cellar: :any,                 arm64_linux:   "81664491b9249ad9f69539fa93955bb92c6c3e20acc310c506ab05bfa73fbafa"
    sha256 cellar: :any,                 x86_64_linux:  "948e8b3b6fd7988e9721e440069043613aa7fcd793f2637fb6296d20b4554a36"
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