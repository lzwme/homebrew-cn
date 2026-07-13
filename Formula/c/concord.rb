class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "f0f35d2e00c0989a91a01c3ff5699e8d549b2d00003b2f9640a864dc4e2b25de"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39c21fd11937272e9cfe82d8bb273170a969cc501b7d36ede514a2f056c339f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3b14ba9cdbc90b0db4e03a67511e9f03aea48f70b0fbe203848f35c6aaa5039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2897d7990b0e16a7b06db075caf39f05dec81e2db2e3cc00874bad55fbcb423a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aa4cd450c7c2bba6bb3acdfc44185611aec9cda8796a6dd6702d7a2600065cd"
    sha256 cellar: :any,                 arm64_linux:   "94a3920c01a8756ebb5e30e423ddc873bd33cae6312136440a00a0d0568db255"
    sha256 cellar: :any,                 x86_64_linux:  "a63882babc336836fd833974335dd1ae01923b5c1e58a9e94fef704e5500b8e0"
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