class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghproxy.com/https://github.com/nushell/nushell/archive/refs/tags/0.87.1.tar.gz"
  sha256 "92087ff56c98acb86dc14e9566748c0f470ad5f13277dd62bda878146535fa83"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "49e856acbe82e68e45500d9cab75ed73ff1eb6bf9c44dfcd7166a072f1fd92fe"
    sha256 cellar: :any,                 arm64_ventura:  "115b220cf0633c8d6b0c957223e79f217840ab30c4802c363b581a410c06a345"
    sha256 cellar: :any,                 arm64_monterey: "11f36a61970108824eb29c2c566aa7801eef644a920b51716b8b0107ad71cac8"
    sha256 cellar: :any,                 sonoma:         "b1215eb220d94e1b43b4424e22bfb63b496e233e79fda229048ed1bea94ffb57"
    sha256 cellar: :any,                 ventura:        "71e2ece9b84a8d2d86e0de8847a54746fd53f434b226a9e39a1d0fa77bb17316"
    sha256 cellar: :any,                 monterey:       "cce61cd343890d2ffafd91a019169b0fadf9d2bc8e7169e0a480edfa95129783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "324ee2a277f835509c62466ac1fda23b8d1b3c16e59ef024357198d7d149c449"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end