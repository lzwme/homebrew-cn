class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.12.tar.gz"
  sha256 "cad79d392c1b554c59546a1229de5df98c76c1fc56b157a5bbc691c385cc38a7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27f2964cd42bec963e03ca6056460da9e6f05e3e44733804c97e78fbf14174d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc2db71a3b4929f6d531206667a92eedf241fe5689e5c5a55d0e8999fd5958f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86d78fabc04fefe998ae3c1d7fe6f8f5c59e383e4ab115010e770346cfc825db"
    sha256 cellar: :any_skip_relocation, sonoma:        "c804e278712d28060efd255f8a5abc6443042067c2a0bbd78f72121248e15b13"
    sha256 cellar: :any,                 arm64_linux:   "a2227790ca958d125620ab1f67ca1e2d0f05c02d7376065479e2b2a0b54979d5"
    sha256 cellar: :any,                 x86_64_linux:  "a1371caf66a27d99900091859e3869fd24e24f35031cddf0df859a2744184939"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
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