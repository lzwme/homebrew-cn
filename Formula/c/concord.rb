class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "b71faa6f624470ca79d7216419a4bc267575b1428ba098574b9b253ad988d285"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5083b404e6af5eaf382d5f89984cac33a5af6d2d7dc0a98871ba8e14cc826157"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09a964b7e8dfb517bd4a470d1332bf0eb536a86d0727f0e65c9d5880ad7b0f39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51cac46387c083b9cad5e65c0f66fc504a65a7a372f8ace05428744b512cc2cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d813d43fc72dd3ea42c7e60c2fd93692fa4dd73ec83e2415bc7fffa68e0819e4"
    sha256 cellar: :any,                 arm64_linux:   "3e38d17d38e1ef1f49d0d3e9155da10ed0a8e71fe80e1ba8f696ee8499011c36"
    sha256 cellar: :any,                 x86_64_linux:  "33e827f909e0241fb9ce9e03888008dd8877bcd54dcc92131285e19b929d96b7"
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