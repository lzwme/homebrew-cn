class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https:github.comnabijaczlewelicargo-update"
  url "https:github.comnabijaczlewelicargo-updatearchiverefstagsv16.3.1.tar.gz"
  sha256 "0fe05d1dee8fcc1f5ec589a6a16f746d8504c5a9b3a3e5d9d8f0730a87900cc9"
  license "MIT"
  head "https:github.comnabijaczlewelicargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3e7608f5c1ac07b79f67493cb88d2f15180c4537f6b7daad48e82aad6d58b7f"
    sha256 cellar: :any,                 arm64_sonoma:  "6153ccb667f191c235f0c5b04d012c459c3fdab1750b86c07aa431cd7b2f5874"
    sha256 cellar: :any,                 arm64_ventura: "49462621dfeeffd2fa2587867877b455c3b0d325bbe4a984a13d4014ca38d15e"
    sha256 cellar: :any,                 sonoma:        "3bd8eb71d4cefc0e855a3fc4753bb6aef133185b8591264e27930a10316da762"
    sha256 cellar: :any,                 ventura:       "5464ffc38395e863379a2789c79e760a89d3505f425b775fc526d3965ccd145e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b81dcd1a969efb8ef685a30d981e4d962d934d09eb9f3d4cb53cd494155779fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "173bbefb2e1b54a98b7035041692db929c1d404deb6c85eb9071126f11ee9728"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end