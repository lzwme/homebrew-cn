class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.19.tar.gz"
  sha256 "1ab0b2a11ccea934f83fe381732741c56c49891350e59431085c2f6aa4ef7f36"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1f265da077774c7f7d4174d2e23292c5c986833263a85aaebbe1dc34eb593e1c"
    sha256 cellar: :any, arm64_tahoe:       "b9bbb3fff045adcb93ccf7c6cdcc1405380c6ed60cecb958a0f3b7043f3c450b"
    sha256 cellar: :any, arm64_sequoia:     "a7757caf30bbcaca05703c2adc9995d4caafbeb7c48551511f7ee9777736687a"
    sha256 cellar: :any, arm64_linux:       "8581f772a7f2931aee72dc2d2dbd69bffe3025d88b1b0798b71533e5107b9b0b"
    sha256 cellar: :any, x86_64_linux:      "766ee66be823e68d6630a6896d2a83f6670041da70337fa9cd75cc49502cbb3e"
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