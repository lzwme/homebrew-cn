class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "bea0a0b755638171bfea761ce9d6bd48ca8c31363ac931620de0994085d67572"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51eea7bf757f75a2286bd6a9f5ca79ad2780b6ad5a1fbe663e2665434f1b6c69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5675bc42149c3a345ab4bae10cef61a4c2d6db40b81ffdfe222962390791733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b49dbdb37a16f35ecd2b80dafb46aa561989127a1d6f925a219d98d430d2f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1537ef19385b2c5d3ed934735c01ac8c0101156b14f3bdeb96b25c5cf1ab0d61"
    sha256 cellar: :any,                 arm64_linux:   "f54e22ea68e0efbad38e13e977de64b5887e8c9336f2b8ea9b8e022317479d14"
    sha256 cellar: :any,                 x86_64_linux:  "4bef700873eb657f9dba6fe43f18f8c1f7a209b02f17f873628e730e7a54b92c"
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