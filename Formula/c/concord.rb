class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "0e44926adcd2a830b97fc16cc6c9e98ed4e456792c1c712048a9bc72509a8d94"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "971159554df08f336e305efe3e80739e90f513f3e8637267b6d9ec5eab6cfe85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f319c99cedbb2820a76bb25bed056171c6e1a5c976d760d59b37335d23c0e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abff6569ef0ef04d269075f546777fbf238c4e971f57eb807da26f184421fdaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "81be1477091c3afb3e2a27d6a5190e8b79da72ee19ee3b0f904c53fdde115d49"
    sha256 cellar: :any,                 arm64_linux:   "4bcb156072f6410d70ad2fb96dbc128490c243ba05874262c8af0019bcbe94c8"
    sha256 cellar: :any,                 x86_64_linux:  "6879b9684fbf7173cd5b6553a449cf2e50dd6d191c772d2cad585c7f765e9d5a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "pipewire"
  end

  def install
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