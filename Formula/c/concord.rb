class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.4.7.tar.gz"
  sha256 "c6ca8a51548ed2c7feabeb4066760875ec883fdc927d7e84ec024e2758344b8c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24f9a0ed74861d6366679d9dc77282196fb9d5a46c615f197daac39a48bc8afa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57abca4fe5b4884c53325ab18b9eeb61a86aa8c7b6d034c217493af07d434c51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b59e919a39c013d987b40dff3b187bd1d278922bef62c6c23086ecf5175eec18"
    sha256 cellar: :any_skip_relocation, sonoma:        "12127f8cd79dfc8e5b8c08a751d8f5e2e7a39ad2e343f27a9f62b76cdeebae0d"
    sha256 cellar: :any,                 arm64_linux:   "a5b9d477d2767234e1fc289e2b9fa7682067201204f6678bb39c776c516ed926"
    sha256 cellar: :any,                 x86_64_linux:  "4eef9fa8dee19aeaf189a0ab2575f53e94da45dac7f1f619f83aa5f74f387185"
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