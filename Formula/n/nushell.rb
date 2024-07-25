class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.96.0.tar.gz"
  sha256 "ed3035487b2f6eed0a958532edd68a379617649a9381480726265f15dd6eabad"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1534549a79acb9c0dafcefc75fb48f83e5ebeda1633d8178b013365c61311e6d"
    sha256 cellar: :any,                 arm64_ventura:  "121304bf3a66f5336d9a5974bca3b21fcdd7ceba51ebfff58425d1e9604f1e3c"
    sha256 cellar: :any,                 arm64_monterey: "4b6226bd5587e70a7b54cb1b0e71bb0451dc11bd55468daa73143b57992ce02f"
    sha256 cellar: :any,                 sonoma:         "3a2f6e247fedc736ed71fa642411b07881f2bca6a0c94d8934545873f5c6a488"
    sha256 cellar: :any,                 ventura:        "a0e7fb89055f912fecd16fdb7dd465222478574b86fc202858480c4795da3278"
    sha256 cellar: :any,                 monterey:       "b24139110b100354fb4ca43b3f5e3f6eec4738627853b1992b90f426004a9a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff9b131226749cb70b9a0310bc983766bde15fa810dddc2a707b8690088bc71b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
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