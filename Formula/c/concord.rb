class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "ea07bb13db7de8f2b810d91a3ca1ad75551063c98305514a675bcfb4160ec311"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "563d2ef3633d35de9f3f74bbfd964785cbf9b9a586802d5d1ad74bc1c117d8c1"
    sha256 cellar: :any, arm64_tahoe:       "a084fa44fb3793ed1b3cd611c2ff85637a3ba588d0d0a66a0200fa785d38d926"
    sha256 cellar: :any, arm64_sequoia:     "cedaea65c6306117cb0735d0692fef2797432513385ca54cc98a687532ab15c8"
    sha256 cellar: :any, arm64_linux:       "a0cedbf4c658af8d639d9d5b16a9a90570034409435e79e8d1751a6e88f08046"
    sha256 cellar: :any, x86_64_linux:      "3f15a5fa6a2219af8caf36cdf321efcabf1749194bcd41e254093cde7c6c2a1b"
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