class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghproxy.com/https://github.com/nushell/nushell/archive/0.76.0.tar.gz"
  sha256 "952d2f1dd2543eb823dcfc9edf83f0cbe90f0b9adcd8d8dd37f44a9c21c83287"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bf6131070043aa3b24bbbe1ede45563fb039d84b6a4ec7e6a5745e1e26dd3138"
    sha256 cellar: :any,                 arm64_monterey: "5b384283151405bdd9e98ad17f67a7186805e985403fccdefbebc44721b45b6f"
    sha256 cellar: :any,                 arm64_big_sur:  "2ca922eaa4b9a464b84bf5ca0d03c401c957b0a9d0ea74c1042f6190e65bebc8"
    sha256 cellar: :any,                 ventura:        "df0daeea8de08aef31078e48e8e59b7fbf38390773a5c9fc85009d2fd0c7a501"
    sha256 cellar: :any,                 monterey:       "2e0edcebe1fd1c5802166bdc17a48fdca41147fdbe33284253fd911a0c650008"
    sha256 cellar: :any,                 big_sur:        "d211d813f9c86616a39cbae2230e3d73c3d09a82195aa6491e6003866295b3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d7d82f64287fe4c085c1378cdc33da5b3e07e718c941732863eca604c4923d"
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