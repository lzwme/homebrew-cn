class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.9.tar.gz"
  sha256 "3b0818ea45dce36157b2e813fe6c071b26422b149390f354d4ff9e90e4ec3484"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9970d9fab45baafc02ebe220bdff5b91d65a926200e1893728c139d791919243"
    sha256 cellar: :any, arm64_sequoia: "769b9063e7a0f79f5bf8da756e262b880958940b59e87465794bf8926067bfb4"
    sha256 cellar: :any, arm64_sonoma:  "90939da552bb57eca1d5fc3e5c6ce4c7b5bb85029007e1731888410a8707994e"
    sha256 cellar: :any, sonoma:        "295e7b030874ad601a8cb5e339a8262be81a85603fb6add2fec01554b4faa6ea"
    sha256 cellar: :any, arm64_linux:   "78554bbef2054c3b7ab2b7113960ebad81fe1aefe0488768034e5fe10ddc8835"
    sha256 cellar: :any, x86_64_linux:  "3e268b08f6d12fd980b2c2a49d3cee626105bf2570810006cc6897091703b484"
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