class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v18.1.0.tar.gz"
  sha256 "bea4c83f689756b8483faa3b32de1fb2a7730955717df72ee6ebf01cfd8ca4ea"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e13f395b961b1bc9ccff775f2d36a744b6d8fa92980be44143391f5acaf9d87b"
    sha256 cellar: :any,                 arm64_sequoia: "2670019f43c7967407156c65cd12977c3575c713847275f336ba06254301186f"
    sha256 cellar: :any,                 arm64_sonoma:  "fb22189534df4de341181f41c3d09172ad57030c3b9dd33d81cfe03039acae73"
    sha256 cellar: :any,                 sonoma:        "4ee36a18a1db17ff2ba0784a0c8b132e24f16c1169c16a4a2a8d47c07561fe03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba4055d1bac857963d67d4cf590a89d615862a1b7b797c01f6b758e31e8ef318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123ffaa1e55d375731036778b1082dd62a7e04856821f7e24687c06a764e12b2"
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