class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "acd18ab557b946af42b807f944248635e6b087f08cca23e0fecec4ce8c7f6b89"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0ff17f02a597173be7ae2b3a141a90d141a4bdd2d08e73335afa15d2d942e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b77b851a354b906ea8389c7de785ffaa46c1e28c7469929e358d419a12cf8e13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b612ea0800eef5701020fb5dd82d2c59628a038f1850febecfb77a97873dfb32"
    sha256 cellar: :any_skip_relocation, sonoma:        "f029570eac189fcc2b77d4840f53dce5f57ca8eb6c6dad8802936140591e5338"
    sha256 cellar: :any,                 arm64_linux:   "f1e9a7219c0a0c83888419804d66ab3ae171d5d3034dd72297680904068caaaf"
    sha256 cellar: :any,                 x86_64_linux:  "f9f45998dea09616177a7347b5200d5232d58b5336577369f33aa4663acffaa8"
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