class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "b98654868033f9a5b3eb31c03fa79e3c2e7374648b1886bc19914cf59d3b4485"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb96509d50f15f036df43d9819e452ba7900c82aec375788b0efcaeb0f595bf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1dc652f3528f8fcb46ee2a39292d3acd6790099a1a7c3f818efb3e0c1f52a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c079bb7d411e0791b3386b525627d0bd8c69c317605e4a703cb8174be8b7a9c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "75971820f4fdff24175dad3f8145c4b69f1541c79be43417607b5b88c1fa483f"
    sha256 cellar: :any,                 arm64_linux:   "f1f460cd83f7ba5e790ca18c0a3ae8b570abea7e378b03ded31a3626b67bc92f"
    sha256 cellar: :any,                 x86_64_linux:  "d3486fe88ebf4e2093f6e51142aaa9e6636b3dce1837aa37ff8c0160fb453d30"
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