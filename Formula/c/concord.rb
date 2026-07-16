class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "28d0385738ada1d49fcb68a9dc796ab03669347b1cdb9a27001cbfbe29e02391"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5578395cc3b08d89711b059a8cabab323c81aba6acade77782d81733b2b1dad2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a926e1e9cd4852d7a161cf822c9eac395d6bf0d7295a490d50b089968a5eac6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09737876874c228dd2cea62669800096157680b782a8ce39398c29edb7ff4f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0b73734078d83efb1e9810269d9c920e043857231f0aaa33c45bac24044d534"
    sha256 cellar: :any,                 arm64_linux:   "da8499cda738e69b344ca04fc5667278223606505c0d0fd7d279b77f5fcccc95"
    sha256 cellar: :any,                 x86_64_linux:  "4a84eefcbd54de80c7b2be8714da1b45de3d6f176b8e4fcd719ca18d4aec9015"
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