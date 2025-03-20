class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https:github.comnabijaczlewelicargo-update"
  url "https:github.comnabijaczlewelicargo-updatearchiverefstagsv16.2.1.tar.gz"
  sha256 "2436675baff66da3cbcab1126427f7a9d52375bc77041000d047a805cb24b244"
  license "MIT"
  head "https:github.comnabijaczlewelicargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad1ed3704f5cb96136c97ffa64a92bcc33459cb2118d0f45d09a2889871c8950"
    sha256 cellar: :any,                 arm64_sonoma:  "eada3d2756b2d4b7d36ee19156e057517f535ed4c94db20d3c751bbae571c4f3"
    sha256 cellar: :any,                 arm64_ventura: "623d28d4dc2f5cfcc59118231803b1514bb4b06112d32d2999570edafb395012"
    sha256 cellar: :any,                 sonoma:        "2cd722dbdea287aad68fcbd4a0d9cff56f05306c394e483ed87bb366b79055d7"
    sha256 cellar: :any,                 ventura:       "6dc5fd7cd72a20c8ecc77f210b8af6ba4aafd35aa22d420e10c71c443aa2388c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2ef02afbfc0349abbeafd5daa6f4f62d309de834f3e038d0dbdc3baafa2640d"
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