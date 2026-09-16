class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.21.tar.gz"
  sha256 "dc918a1df0b623d9abe48154eb03c7a5e1bcf90f059eb073df4b2330df918f76"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bbc2c15f8ec05104bd33212c2295ba6a53649f36dda77bc2303c2fa660012066"
    sha256 cellar: :any, arm64_tahoe:       "ed16430ae985d1250a15918688af7261f1f279a77a6c2429df5bb2e1c6bb805a"
    sha256 cellar: :any, arm64_sequoia:     "649a8225bbbddda0be59776274fee78085809a867ef0a7216ec51a6e0c9aaef5"
    sha256 cellar: :any, arm64_linux:       "e445b9ef81af5262e076c68cd6b71fbd8798766ef68e2483f0aca657bbe38d35"
    sha256 cellar: :any, x86_64_linux:      "fed4e9f171f1dc08e90f6a87e03c8a40d2c82daf54cb6af4a6d4c98352bf1e9e"
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