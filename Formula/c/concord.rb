class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.14.tar.gz"
  sha256 "01af3835b4f645b7469acc0a72193e1d0006cd7c0f1ffce06c355e6bd4413ffb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d09fb54f7c0e01124cf2925a6e3aa60dff0bebe064c671185c31f04907a12e8"
    sha256 cellar: :any, arm64_sequoia: "c156edf808b0dc66ef59c94ba08d54934172cce10e55a99a4a4eb91fb7700296"
    sha256 cellar: :any, arm64_sonoma:  "a4df192b31e449e106a8cbbbc36131d5462e505b9b28699e655d01920f00c1e3"
    sha256 cellar: :any, arm64_linux:   "9156b03e05936efa53e4e53feb7ca44c650287175118031477c279b1befd9d2e"
    sha256 cellar: :any, x86_64_linux:  "52cfdfa22c51bffee0f925132b3b36709e117b43d450091dc9127f7ef9e53d35"
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