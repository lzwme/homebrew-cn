class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghfast.top/https://github.com/nushell/nushell/archive/refs/tags/0.116.0.tar.gz"
  sha256 "1174d023ffc8083750daec8ee2dfe6486a8ef9f5c22396aa675b61d1bb0fad2d"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d603b3f6afa449b4ff7c1a323a13e3b31f9e26d43f663d35ad3e4c6e26d75c1f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2570af2675749c20604afafec125580e5164241b05871a96f9bee1fb89a1bad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "daf066540cea5fa5ec1e51da261aaf62b11b7d04d961dbda524f2b508638adb4"
    sha256 cellar: :any,                 arm64_linux:       "19b38f0346f4a6a82a2970a36c921eb455b26255ea42b1a04db4b545c5c2fbcc"
    sha256 cellar: :any,                 x86_64_linux:      "c274b7a9cdbcfdb2c1d29662f68634a8a9dd572d950bfbe5c013dece7318c5e7"
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