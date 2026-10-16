class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "8e13216c2510aa2e8cadfd6d9147f41aa50edc489d5c9033736b934166da497a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "007aaf3a78776f390d4fd2da0fc2605f609f189d2ef83aa1722d5d88617aadf4"
    sha256 cellar: :any, arm64_tahoe:       "16b72852297b6361f4943efc3593d1c814c72ad92b4fa53d934908d31758f5b2"
    sha256 cellar: :any, arm64_sequoia:     "77a8cbd6579d9b7355f76a320824ca345e5110125486f268a24d0cdb6615e7fa"
    sha256 cellar: :any, arm64_linux:       "3baeb8e1e56df4db158279d4ce4e641e407d0b05f429258296b9bfb830caf453"
    sha256 cellar: :any, x86_64_linux:      "c4d01917042c358d3e82e49e5f9d134ebe93674451ce1413ac44decc38c06f62"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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