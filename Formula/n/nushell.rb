class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghfast.top/https://github.com/nushell/nushell/archive/refs/tags/0.113.0.tar.gz"
  sha256 "a259330216587e76dc48e065f3c2dc5070255931bcab37e46a3958fb1c8fd223"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92ebb7e85cbbfe39dab0cc30566be8f5dc98db28f284155427549aab9e85bd58"
    sha256 cellar: :any,                 arm64_sequoia: "f97fb98e6143a94bf82ab74d23e6fd657bfc2462caaeae988e1de64508c6ed84"
    sha256 cellar: :any,                 arm64_sonoma:  "1bc370a59441219a3e30e422a95a4ebf805b50b9f04b7866e31a7dafb395695b"
    sha256 cellar: :any,                 sonoma:        "370433b93f4666c9ad28f72a6c1ecd871456b699eacdcf33c7727b2594ae1e94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7de49405a605946aad8ec6a39946c39ea22027b78d7b9824409c2637443ab5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ceebf2317a5bad4bb69bbd7a4598856d938dfdd2030229a2c0420e78a90058f"
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