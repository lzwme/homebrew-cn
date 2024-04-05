class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.92.1.tar.gz"
  sha256 "bd4d0b90ff7ba53ac888df755372a794a907f93963e26ff8f441347aa0ff5a95"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4967d4c2f67350b026c3ca36a21d9707f1542d3d6ba7d97fbffadf3c150b3184"
    sha256 cellar: :any,                 arm64_ventura:  "3bdc4b1b52d2b388c69d5eedb068bb736649bd2fbda9021d0c9ef75be793c232"
    sha256 cellar: :any,                 arm64_monterey: "cef0b01b8471eb26d9fe17fde215b5a2be18e5586db08df9dc33795c3e70b9ae"
    sha256 cellar: :any,                 sonoma:         "cae82080c0e5a3b4d93a6f3ed1d4a703d1e8039490877d5cb98eefb90efccd48"
    sha256 cellar: :any,                 ventura:        "f3ca6742623a4719f3c9480f2bfb52152eeca00eed0380defdb055b263262553"
    sha256 cellar: :any,                 monterey:       "27d75044254f5a6bc9bec0dc16fca99246a9dc358ffc2ace3c8003075b838e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e43b62ebb3922adbe4edfd87109594353ea87942e36b96716fe10f032a104a3a"
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

    buildpath.glob("cratesnu_plugin_*").each do |plugindir|
      next unless (plugindir"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end