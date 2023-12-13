class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghproxy.com/https://github.com/nushell/nushell/archive/refs/tags/0.88.0.tar.gz"
  sha256 "6272a5c17219156c82fe22aa4fdf5580a361a3c8150114a4046e8df4939a2797"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e37ff1a15f3579735ca7ededd6dceae60ae737d97add73fdeb36061357b6894"
    sha256 cellar: :any,                 arm64_ventura:  "878d285685b5b9736eeae91f240ba97e852f1da61afe3752c1eeb75a8c80468d"
    sha256 cellar: :any,                 arm64_monterey: "8477ce4a4025c932c8b62c7c6c9b61bc0c2f4a5c9054cfcb6c0274942903afb7"
    sha256 cellar: :any,                 sonoma:         "ae8408b626e093a2942278b7312ad47d14b8f9ef6c169b01c4ea141ad34fd562"
    sha256 cellar: :any,                 ventura:        "7f07e372ba201a880c58202e0e903982a9c0621cf2a8ee809db028ef5b30894f"
    sha256 cellar: :any,                 monterey:       "cafcd5a9742da6b81b53abd4b6b4ca81d24b7eb0a767875b13ee073951ad5a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "368730e9bbff2cd96e3527f7b053101f75388bca831d8760519d4e17fc5571a0"
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