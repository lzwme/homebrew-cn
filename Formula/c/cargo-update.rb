class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https:github.comnabijaczlewelicargo-update"
  url "https:github.comnabijaczlewelicargo-updatearchiverefstagsv16.2.0.tar.gz"
  sha256 "5d7f8f2b0f707834f0f33f8e975603eb0b605ee55aeb065591683ff5d1aff971"
  license "MIT"
  head "https:github.comnabijaczlewelicargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d960002f63b43f1c6ec842cd7463d8b39922581ddf95bbb08e1d640dbb872c8d"
    sha256 cellar: :any,                 arm64_sonoma:  "9e9f20f39e2e9e750a38c57d2992cd186c72928d08a21d7cb616c0c216e8b143"
    sha256 cellar: :any,                 arm64_ventura: "2ccc7bd766d978d55f0dd9b11528808f285de68fc12f25f713e80ec6d2308806"
    sha256 cellar: :any,                 sonoma:        "dcca4e57b283d964306985399c0634ef84c1c35edf864b357b0f05688a6e618b"
    sha256 cellar: :any,                 ventura:       "4ab0db1dc0116b26b9df008a73d1ea853177302205552249bc705891abd8e423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec446d87216145f8f58cf0f87091ec7c51ce48bccaf5d5becddc0416080fb284"
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
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end