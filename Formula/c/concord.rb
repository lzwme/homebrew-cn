class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.11.tar.gz"
  sha256 "d88817bffb89b7d27f77743ed000a46cda04f134e602a1ccdbff795fc15018b2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "63c1693bcae7520f775bb309bd506c6258e5f0a46252abfc00d9d585d57391e0"
    sha256 cellar: :any, arm64_sequoia: "af39d92f605ddd8641761d58013669a695de2b385ecf5eaa0d9a5c052665026b"
    sha256 cellar: :any, arm64_sonoma:  "1b668bb9aa1f0495d99a799c2e9c409d5fb8c66224bc19bb34043bb3b6f4be7c"
    sha256 cellar: :any, sonoma:        "1fd6974bd1464ae7e6eed7765eb2d35c5e456b8b76b9cd9765d75db8100457fd"
    sha256 cellar: :any, arm64_linux:   "55ff377dceaae9e3444c96612136dbe962218adcaa4f07282cd32c4d1b49454a"
    sha256 cellar: :any, x86_64_linux:  "ff622c324d3ba4029051de49e9b40d0c4a010d311dd88fc162024964a3d070a1"
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