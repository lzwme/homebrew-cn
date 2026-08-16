class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.10.tar.gz"
  sha256 "a0365fb8036f0740958114f094d0113349dcf72e20d8bdf835f3bc3cd5e2a5f8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1151a82c3f6362249c655ab1482c96592c87cf48a9cc429a4ea21399497c9ddd"
    sha256 cellar: :any, arm64_sequoia: "b9fc7f7f44e161df43ce7f93070e19d9a3ac72a771b4f4d3dfd5a7b07d0741a7"
    sha256 cellar: :any, arm64_sonoma:  "a3811c9b6ef9fa49fc3314a73405a2e5e979e33feeb4fe2d3f81671a516b80e5"
    sha256 cellar: :any, sonoma:        "85039e59b6d0b942f5fe3359ecad0978879c62df4269d05f802541efef21dac1"
    sha256 cellar: :any, arm64_linux:   "efd480f01d7147f2984688964801bff8cc194bcd6dfce40edf1aa41dba148852"
    sha256 cellar: :any, x86_64_linux:  "23f1dc05fefb99c10c97122a0878eeee1de6ea94a9c4ad43fc05feccd4c7ba02"
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