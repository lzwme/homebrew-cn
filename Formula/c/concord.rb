class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.10.tar.gz"
  sha256 "6caa67381e3b12bea0263cf18807aea0905707296bc4c8b2c4399924eaeb824c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "702e5beae5ad562ae59976da6e1946955fb551944f6e4b63ca8afff6b9099393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffd6afd78e76dcde54064e4e3a04cc45294d1341b662e1471cf524d569035419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2cc72af62cfe3a36b012d12f80d7f1cd1fe9d2775dab4d62e48dcfa32b34319"
    sha256 cellar: :any_skip_relocation, sonoma:        "36e003f6c79dd31d86acc0275e118053affd8126ce25b1fc87893bc3c2847c4b"
    sha256 cellar: :any,                 arm64_linux:   "4107743ccd2b69e4f9879c465a548845b1cbfacbd9e1fc463f0e69b1b5367169"
    sha256 cellar: :any,                 x86_64_linux:  "93094c68777a8e294c2098b03b7b9c4a740869cd7d179fe4384806a39a747d22"
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