class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v20.0.2.tar.gz"
  sha256 "729d47a7fb4c97e3460393bd70b1f3f0efce391397e0aac70618bed80c2336d5"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1a63a75b036853703b5f341ebe2a7c1904f7c23cd1cd43d877eefecb8d47df15"
    sha256 cellar: :any, arm64_sequoia: "7a7dab56606b164560a70722aac791759b1f28d957b275985c0c0439277a6d73"
    sha256 cellar: :any, arm64_sonoma:  "cf41a9c267ffbdc63b83b44c8f3b3ae1d03f414b4c24e0f4c7c3f0568c24d327"
    sha256 cellar: :any, sonoma:        "59d2fbc276591c39f8728f7d51444557bf993eecd6e011fbff73202d3e85fc55"
    sha256 cellar: :any, arm64_linux:   "424482c6424f3bba02c229cc56b4b97e92326f9797c88dd238760feba80d716e"
    sha256 cellar: :any, x86_64_linux:  "9f3e5810b15e8fdd4b4f422a70fbae68efa82c216a97cea865eed02a8b4a321a"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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