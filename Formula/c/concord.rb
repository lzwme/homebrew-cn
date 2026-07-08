class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "9b3ca0883522a998b355694efe65dac580f0dedb355cf6443aa71f56e79182b4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db72b6a870e34864b22e8d73f399e5bf1a2f6e6c9de1552b00cad5b4bb7cade6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3804dc15c5246186a698604828f0d6113c94d80924ebf7c06645b5dc40042b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a8d150cde35a82757ac10389e447e4329cd5979cc3decf08e539ac1fda0b7da"
    sha256 cellar: :any_skip_relocation, sonoma:        "fabac643746c568681e43ef326446e662e400e514ac2c7ada106ce23bd7226b2"
    sha256 cellar: :any,                 arm64_linux:   "f17abc449483fafdb03338d190641fd2a4b33e6fea17c2873ad86b5809f3944b"
    sha256 cellar: :any,                 x86_64_linux:  "854d3bc0b4ebd037584025c74a23e20971d96f2456dfb69a400fae7acb66699a"
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