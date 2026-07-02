class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.11.tar.gz"
  sha256 "81cbf51de3dd3a81cb45741758b8ea4fd76c69f5141a6b70595c76b2e58266e5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20f8adcdaf3c9ff70098a7317711a1f5e58e413bcd201ab34a0ea7eef5d16ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f225fb5a8145e8c30b0b9ff631be24240dce7ff550f6fd2a7ba68e3673e48f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e133b7d3240a4e05dc8c489f28d5f3e4f8441b95a9ac8f2dc9f2a2e162936462"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc5c9973df03993b92e87548a6e092e74fe26b9a26e918059361bfe2606d5ddc"
    sha256 cellar: :any,                 arm64_linux:   "595e873748c6f4c58bd77becf8e9d59c66c9328cf8acc9c61f4c0e295592c467"
    sha256 cellar: :any,                 x86_64_linux:  "8ce1254ccdfb639e3e21e736bc578e32c1e3dfd1d34c8160c4440755702ddb73"
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