class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "0a4419088862a45b255c5b421a3bca6f7373922b19ab54c14be3a0a8ff6e671c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c3c3c02ad8e15aee0ff281019a6a6566e69e6016209c51f1a452e52360ed056"
    sha256 cellar: :any, arm64_tahoe:       "e6f4d6b4cbc4c3342a1e7683a45b1ee0c4667792350a74b71b5649964b17d9eb"
    sha256 cellar: :any, arm64_sequoia:     "3c9e93ab4dadddb3e48b9d17117eda0c2dd63197b4120cb06be118403f61c568"
    sha256 cellar: :any, arm64_linux:       "46fe0a6ad12ff4ce4ca9d2a032f5979b930e27beed3cc0b07e764a9caabd2020"
    sha256 cellar: :any, x86_64_linux:      "1388d38db4612da7a362d8f35137497ae34698ec18b5a3085afb8c85ba024e83"
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