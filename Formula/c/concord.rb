class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "2cffd325eb934c07fa186f78544c2ffab312f0f15fdaa0586fb8eae9a88388b1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "69f0fbd773bf61176a9d9b9b15ca631a653464d1554d9e4c3a087144ed94e3d4"
    sha256 cellar: :any, arm64_sequoia: "5c272330adf0145a9a6f676361a6e37a9c0f9e700f9623beda093400313afdf6"
    sha256 cellar: :any, arm64_sonoma:  "581d0d4b5b1ef3d69d058531816f77c97348eac1387e83ba34b51fab73e1597a"
    sha256 cellar: :any, sonoma:        "94999a3d079b71518740e7f8316f1273433a5866dcfacbdd33357bb2a5d1d7d6"
    sha256 cellar: :any, arm64_linux:   "a95dabbf6f6c86dfa42dde0947f9dc9478d53ced7c8f957bd17c1249e6e5a746"
    sha256 cellar: :any, x86_64_linux:  "99e58c7210788414b9a232d2caf16c7235926b7ba3105f8a4380654308687f0d"
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