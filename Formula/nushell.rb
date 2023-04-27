class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghproxy.com/https://github.com/nushell/nushell/archive/0.79.0.tar.gz"
  sha256 "cbabc26ce509c672db943f3ac6d44d1e3efbafc3b5929411ac209afe14848ef7"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e228c97488b1e02c64819fdf0423332ce35737b69d28a58f6c41c63b0cd3f9b0"
    sha256 cellar: :any,                 arm64_monterey: "0faa862792c6a8bcb0d89ffd66af3da1f3e906f45029348f160af9cd8e5772a7"
    sha256 cellar: :any,                 arm64_big_sur:  "daf90a0b2b78d278edf1d588eac58d1c32674d41bb986c114634bb7282e2dca0"
    sha256 cellar: :any,                 ventura:        "a4eafae968a0176b12c7feb7fcd94a38a73a359a42d7e5ce5522c83c237a05f2"
    sha256 cellar: :any,                 monterey:       "7a7900ea23ca0c210b73383eda64199bac45804fa4509d2d6ce4449512d13a03"
    sha256 cellar: :any,                 big_sur:        "40e8bc03760621182254cb277eaf1da0860d13d83a95b7ba67e2667374ddbcc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36869d8d78ea88b1c69dcc26d4e860e2a08023ff278c2cbb9c1ed9af8c888968"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

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