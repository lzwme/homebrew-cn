class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.94.0.tar.gz"
  sha256 "697a3cc040f673c9eb74e31d8f9cce85f5d4d5302ea34277cfd16aacf9a495a5"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e680cef7bcf408a8bc3057e8dc64d60f42c0df95e6d8b1c805859e581d778c57"
    sha256 cellar: :any,                 arm64_ventura:  "5c44840cb7b92c745ac68f6c4cce0f86b5a55a7816e4c1843fdcb184be9bc739"
    sha256 cellar: :any,                 arm64_monterey: "02ee31e0cd1ab37c3f3b2ea47ae8ac6fbbad86b0b694a5343de4e5b0eb259811"
    sha256 cellar: :any,                 sonoma:         "0bc052b318bfff96c95b5678080e5b12f2cede36b8319a561805ec8fccbdd4f5"
    sha256 cellar: :any,                 ventura:        "86878079b92213d7ba91e62a93ef7cb81499d3178c51c61748c56e24f4cdd9f2"
    sha256 cellar: :any,                 monterey:       "c75b372c131921d80eeeb76d29585a662aa2e016e18196214a5c350299532f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e36713dae7308c47ea8a07e399d193099ae5091d671ecba82c4447c8637a19f5"
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
    system "cargo", "install", *std_cargo_args

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