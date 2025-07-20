class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v16.4.0.tar.gz"
  sha256 "2b47a69d0f0508c733a388330393ea5d15bc2878229995885fb1ac9e1493f166"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9dc4dba12d6fae1c6e2d3faeee7db7ed7c787e1342c952235a6b937768c15c0"
    sha256 cellar: :any,                 arm64_sonoma:  "2207d10e0254865910b089589bb76cb6f86960d9e40a16eddffac046bc27d203"
    sha256 cellar: :any,                 arm64_ventura: "ceb33a463c72e054e3915baa72edb1a2a544bc2fa99690946058483b89150fb9"
    sha256 cellar: :any,                 sonoma:        "ea03f9a07c3bd1849ba253924bb37c69e4c7952ecf079c346f4d5e84742af51d"
    sha256 cellar: :any,                 ventura:       "ac9382a59336e346887db22e5b4f5b1b164fc40ad88b263951972f4db290aa98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b33a80388c0b47da95efd7050c97dc1717832c7d8d0f7df9ad7f17784ef14f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9ad9bae6cc3de6f58e1d46b630bd4302dc729e01b8189858936f3977365012"
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