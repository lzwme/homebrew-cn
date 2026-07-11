class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v21.0.2.tar.gz"
  sha256 "e67c56e727c85fbf2c51f0fda687ea153008ac4b9f9b501d2bee8c9e7f981c5e"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "15877129278defbffab601caf5241755941581a90b4740f878224fbb71492f69"
    sha256 cellar: :any, arm64_sequoia: "41f38a50162c344fca536c211a3993523ebd511a22a26a00b720241c3246c07f"
    sha256 cellar: :any, arm64_sonoma:  "a4096cf3f2d1e25824e07593152f6b790a5b2d655c060d52a1d4dca057f4fe2d"
    sha256 cellar: :any, sonoma:        "36d1338f2adee9872507ba03e6a14d4beb3dd870299cb0e34f66ff166228af36"
    sha256 cellar: :any, arm64_linux:   "fd1b30b5c6d801959b15b822a77a428f8f4ec270d999eb6000e654b4065eb40f"
    sha256 cellar: :any, x86_64_linux:  "90437779c53d7a14af22d8f8f010c62a425519f5e01e7dceae19015f0a367663"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end