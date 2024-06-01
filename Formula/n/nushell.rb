class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.94.1.tar.gz"
  sha256 "b1686d03727536f42a2592e332955fb005d229f7db19f1bc2d8b0c759ec4c979"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af6223a8a3f2afc87b6e5bbf14f19986f56cf2913859a6155611ee8276f7cef5"
    sha256 cellar: :any,                 arm64_ventura:  "a2622d1ee40c81dd157f402aaef12e654714ba06fafbbed287c1490d52109cee"
    sha256 cellar: :any,                 arm64_monterey: "9766d8978dce7a862f1442d04de7669d404b8345dc27c8c1056b2de4e4d6903d"
    sha256 cellar: :any,                 sonoma:         "1e0a59526b0ccbee473a5110718b14fb0eaa081c645666adc4bb98c77a8de1cc"
    sha256 cellar: :any,                 ventura:        "ae671f691749098540662f9d76c55dd4f0b7121c772c3c308daffd844203e80c"
    sha256 cellar: :any,                 monterey:       "58682056c0fb862c9579a427c2a154f4e5565d9616f06765f445e4a5c63678a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ecb1a576989c555462d84978beb9ed6d335611488c31dda21cf8540f53734c"
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