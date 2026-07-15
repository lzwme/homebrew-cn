class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "104969ac6e1a0f0ceac33f734622377d73e6532607589229580417df1eb9a20d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49af1847a8911d8f081d2ca24f4cdb2bf68f67a2921b335b8e4c494ffe321a0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200158971694613da913fd03409fa1af0d460528a2f7a1a83017775e108ceaa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "996756ab36417f228970ed59dbbf6e01b112697e95b9d270f55e086868d4c1b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c74833ca3f24a25373111edf895ca9343658b6ed6e8153d4073e0eb2235caa"
    sha256 cellar: :any,                 arm64_linux:   "5d34581bc687b05e1b061435dd6aca678c67f0dc8a328be2b9db60e51bcf6cf9"
    sha256 cellar: :any,                 x86_64_linux:  "276ae6a0839574f9ac91e47ecb3ad85c1f39c11d1734c05df1746d28e6d51e60"
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