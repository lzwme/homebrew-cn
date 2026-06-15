class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://ghfast.top/https://github.com/chojs23/concord/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "928d8e12b393d5e7ea6a8834c26a6c778e3cefd2b48b996c6b13f3436d5186ac"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dc1dae6bf34ef8a407ca7c387b61b350b6e20a4da9a161bb454e563a613a64e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0e16388b049280f0dde42fe8fd0b16ff96dfc03ddb43e65756d77fd203cf0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "069c1e077338de0d35646cb12072b5e5414773b9dc82bddf11144a670a482531"
    sha256 cellar: :any_skip_relocation, sonoma:        "d18bc711d380357cc00fd5785a29b4d31bae6cf9d8da35d3cac55123b5a7e6e5"
    sha256 cellar: :any,                 arm64_linux:   "05cdb2701f06cf1601eae2f6838d8bf26ea41239f5695bb4143d229e4ed16598"
    sha256 cellar: :any,                 x86_64_linux:  "609d287cbe4631c42ad6746be996babf89ae83ddd21312f9b48499b3d0cadf2f"
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