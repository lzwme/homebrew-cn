class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.15.tar.gz"
  sha256 "d88cfda6bd26d858cafff4aba98bdb9d2291afa9165c7e4be6f3f0bc48993cdc"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c00f49ca2fdb5a754467e88abc57b05e420b1e623179c5e6958be3bfb19dfdb"
    sha256 cellar: :any, arm64_sequoia: "51613f18ea5a5b90c07793a612657ced9d0fd583c14469ad99eec6cecf2140d3"
    sha256 cellar: :any, arm64_sonoma:  "2e79cba57bbc317c11b6789a03d58eb348cf9eeb0e11d8646e99e85089960bd8"
    sha256 cellar: :any, arm64_linux:   "8352e2edd8b7f2e050afb75ac2044684800963c2b49f7a73fdb0488eb787b120"
    sha256 cellar: :any, x86_64_linux:  "47835e5f3eaf2cc4ce9aac7439337e6b9c554f4df8dd5ce42a00c0ef3a9aa3dc"
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