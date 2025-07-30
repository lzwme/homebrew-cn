class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghfast.top/https://github.com/nushell/nushell/archive/refs/tags/0.106.1.tar.gz"
  sha256 "3e24044c354d050a850b69dc77c99cc503542c3d9d75fed0aef1c12fefdf380b"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7987d9fd99aaafd80ae20f1d2325de947558b7f07f81916b57a992cddb0b47d6"
    sha256 cellar: :any,                 arm64_sonoma:  "6ffc245cdfe62b5897798d901e98c2909547021ac1fdfe4b0b609e6a132b3931"
    sha256 cellar: :any,                 arm64_ventura: "6c9fc3519558462a789b889a967a11ca0f35e59db8ba41ae54679e2fbdb9ceed"
    sha256 cellar: :any,                 sonoma:        "03304d4596846909525242a3372591ca2f686b6c2432c3210697bbcecf8763ba"
    sha256 cellar: :any,                 ventura:       "0ab16c97151eb3dfff9c860a3ba398a8a76321f2a565bdff144191b537ae19e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e18f05e1a14243da43657edfbb12f82296ca1a607408d7a7ed62eb3430e7f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d2065f811be35a7ba3a13987fe74fc0b5557bc4462559c5cc07cd5fef8ee603"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

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