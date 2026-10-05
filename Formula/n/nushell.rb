class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghfast.top/https://github.com/nushell/nushell/archive/refs/tags/0.116.1.tar.gz"
  sha256 "0cca0c5bc9d9eb608dee00c75b6b511917df6e66c784b034468bab2ff0fbb9b4"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0930ba1cf28d06546348cc6476e92b553e2d04893e9c26dfe408b97cb1ab074b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7544b2f1c956665c6bb0f448edd5d3bca4a5da53c65507dff558643edbb9f93e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b7be3a9b66c6a8b6f51bc9d3ac28625eb09966ecc8febd445343edcc83250a7"
    sha256 cellar: :any,                 arm64_linux:       "5b03d3203041620799d03b3d3be38cd7e1d73e3b151bbc95a9a8dc20d07d6877"
    sha256 cellar: :any,                 x86_64_linux:      "7a3001c12276b25a0fd73f0d39d5140e08b81ff62995582a01637b71792dc012"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["NU_VENDOR_AUTOLOAD_DIR"] = HOMEBREW_PREFIX/"share/nushell/vendor/autoload"

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