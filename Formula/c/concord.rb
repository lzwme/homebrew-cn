class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.18.tar.gz"
  sha256 "f3f7cd385fa7717afd99634005302f37aa38cc22339d872d8e09b59640f65a38"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8579430473922d579c050d4f72101bbda6bf5dd0c863ffac6a7db73add183560"
    sha256 cellar: :any, arm64_sequoia: "70c23e86ab034576b964ea0bd4c4da43b5975582143fb8e4be7032c5930cc28d"
    sha256 cellar: :any, arm64_sonoma:  "3d212f35c7c0675a80d352a03404b82349ba813e181f57a7c678c64600d041d3"
    sha256 cellar: :any, arm64_linux:   "0be577d881fa81df9093e4feafbd629deb5d62ba704fdeed60aeeef9fb3ee013"
    sha256 cellar: :any, x86_64_linux:  "ef35d41d3d2c0de97354ec8f8474434ffcec0754d2618b0ffb76e1164e1df235"
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