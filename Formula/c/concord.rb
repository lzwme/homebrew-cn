class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.8.tar.gz"
  sha256 "7004cb55c5fae4468823cf8cd6be3d2876304a551330e8eb80a3c4dc9175a6a5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0f5041900d96b1ab5407288824b1d0cb31cb1d4ab589380220d7c4c55579588b"
    sha256 cellar: :any, arm64_sequoia: "88f4defaae4c8a204d431f6f6a8ee5071a4d14eba5d03f9615a9634eb930421f"
    sha256 cellar: :any, arm64_sonoma:  "b7fddb0cedeb4b2b1452b5ee597fe7a0da5d15b3a433773a4ade965abd262d05"
    sha256 cellar: :any, sonoma:        "1f63664e861bf9f95389fd9c7650ab55dbfefa94046f11293b3085218975a419"
    sha256 cellar: :any, arm64_linux:   "1b3c47485eb0e7cadf1f2d6ab6a5e1625ae76e8a9ca65f500f6c1825cbd1618b"
    sha256 cellar: :any, x86_64_linux:  "8f504130416d6a2a74f7740ced532f9fad806695d0a44b49f01739f6867d0a9b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "libva"
    depends_on "pipewire"
  end

  def install
    # opusic-c bundles libopus and builds it with CMake by default
    inreplace "Cargo.toml", 'package = "opusic-c" }', 'package = "opusic-c", default-features = false }'

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