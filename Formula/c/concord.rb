class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.20.tar.gz"
  sha256 "2a5f3b304c8fb42d6943d86612def8819a8a3724a79a64785e7197d563477d66"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7a5f6cb921a9fd57174fa588c2181f4577c93933585e3806283f62b947eb533c"
    sha256 cellar: :any, arm64_tahoe:       "283ac18bf2112d102ef971040795f3d6467742813638e44edd8612048dd8854c"
    sha256 cellar: :any, arm64_sequoia:     "4b2c8d179370b5935f48f3bb3582022abd02d1c0d7d4d0bb443ee0d0b94d5b1b"
    sha256 cellar: :any, arm64_linux:       "0818d70ee9808a8f355b85ee5ba5adc3bb20e0c1f61964671109e59eef99b8d9"
    sha256 cellar: :any, x86_64_linux:      "b98685f3008783ebc9511fd77b05097594a1d58899d6f64975908941f669c1b3"
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