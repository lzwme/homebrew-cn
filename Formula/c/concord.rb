class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6216dd018ca749c355531fa58d52fcf7116db002022b890b09d8991285654ff1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d91c9a91370ae7885c1c7343bcd4f78e349f6127ab7f0051ae7837d03841a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4064f5458d7c39f6645f745946776def1853b30716fb1354861f7f378558063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d26b4af531aceb864cce8bba997bd93161d60abfb70dd029e299a7ff03d87f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b27b44cec6695bf3a8c03691a12765d5897b5df31338fcb8f052cf5df525c337"
    sha256 cellar: :any,                 arm64_linux:   "35a9373ea88e2bf328a784acb8be6840c9ce823dedf4913ae1a1c06123aedff9"
    sha256 cellar: :any,                 x86_64_linux:  "a2f54bb09eb0711b67ce35adbb12d1a80b79359a300febbd0679acb728571c28"
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