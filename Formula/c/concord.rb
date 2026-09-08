class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.17.tar.gz"
  sha256 "257dd44d55c0c914f399564d68254d5c00e24ae149a3c0d66bbcfb948143e3a3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "04997564ca775ed013972ebc174ee0392cff2c4cab17d5f3fb92ae9f060560c3"
    sha256 cellar: :any, arm64_sequoia: "bfb2933c16fa0f2d187f650427167f0e90b6ffc1454a3c34e9a8065c7e36b59c"
    sha256 cellar: :any, arm64_sonoma:  "cee15e9a0263e14fd7679ce5b31683d2b391c6af9bdc4ea2082d035981706b20"
    sha256 cellar: :any, arm64_linux:   "d96ba01d9a81a47db6e0d1e4a4246ffed2e4b7c857f188df8c1e028b8977e714"
    sha256 cellar: :any, x86_64_linux:  "554c7b8f6a821b31be26112206b8eb4879cc42a72b75885a6e17a1f1eca3f0a4"
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