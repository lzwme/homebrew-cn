class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "f68b0b0ac8af7609d1ae1b5cba84cfc597afea0d10a4e28d081e33edc57d28e8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33ed9da32348202f2ca11dbea17fa9d1c1556338ef15ad4b2b161d2ab738658d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110865146b48c15fec73e3052c18bded628c29a0a2016be8a0e0e5aab534afac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364b80b449b67082668b3fb6d9e8899b1814fae911e4bc7616c1332d9ecf62a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "65242470481b42328460f1b22ec8f662249f40ec40f05432e72df176f318752d"
    sha256 cellar: :any,                 arm64_linux:   "8b2d118fb1e3fe56698505e318d47d3f6e3589f2f8921855bc1a5baeb6b6b943"
    sha256 cellar: :any,                 x86_64_linux:  "bc4355251a7f7e541508107d7fe5ea73c662d8b9519162f24a747b9498cad3ee"
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