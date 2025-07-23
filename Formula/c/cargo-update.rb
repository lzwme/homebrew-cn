class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v17.0.0.tar.gz"
  sha256 "6b8ec8f47c23176e6b17c8591ab63903685c92546e88a5e651bc7fe0343757be"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "834fd08df55876dddc7ef9d02978363cd5d627985e5ee3fe65ae8c655572b02d"
    sha256 cellar: :any,                 arm64_sonoma:  "84f138a6b95a058d5fcf8c8079ef43ae0fe95ceba34a4cb6ea91da10731487eb"
    sha256 cellar: :any,                 arm64_ventura: "8454ee482700cfee051f7f75f05c1a15f942ebba400e28b655773e15dc6c95df"
    sha256 cellar: :any,                 sonoma:        "e8d243285c2c6520484d1279dfcf5daf4fd43f1de15583bb1bde88e68499d98b"
    sha256 cellar: :any,                 ventura:       "61378174baeab03a4da1627c1a04a0479378bb34a56308fba53d888406fafcab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8126c658bc7e1e5655ebc39899ff1f2e18dafaeaca323ca8f1944a5a06ef54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c06e8052d6f6a98b7742c06fc47419f68bb5b0c8110bde9a39a971cddb803d6b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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