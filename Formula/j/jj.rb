class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.comjj-vcsjj"
  url "https:github.comjj-vcsjjarchiverefstagsv0.28.1.tar.gz"
  sha256 "d59b5c0ba6fe207b42299247ef47bedf4f9dbed0171b0c61bb6dece705b7507b"
  license "Apache-2.0"
  head "https:github.comjj-vcsjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf392f32d4584caa727afd6f4ca5d716f1e34d7dc5081be1624d34fc7db274c8"
    sha256 cellar: :any,                 arm64_sonoma:  "b7d36fb354a9b9d353b90f9914e329bd3b727f7bf95beb9aa17f3200c62c8921"
    sha256 cellar: :any,                 arm64_ventura: "4fa7780f0d0fc168b9cb5fdc2a8623aeb8a642aa3738d0353ec08dc9ef3f37ee"
    sha256 cellar: :any,                 sonoma:        "e7633cd701665ed343fd27e2b4c824bbec5d946e64029502cc3ebfa7c05c0ee7"
    sha256 cellar: :any,                 ventura:       "eb936d8f039df6dc22787af344c4f41acb14d4d6f0451fecfc1b476d4386b4a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe1b39f99524e677ee9d285c1e43bf27b9ef3ccb20a3bb7cdce16354ce805563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e511902efecf624f2f0b2e73c4b1f85b2e294c4d06921e92e3a9ed95850a191"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"jj", shell_parameter_format: :clap)
    system bin"jj", "util", "install-man-pages", man
  end

  test do
    require "utilslinkage"

    touch testpath"README.md"
    system bin"jj", "git", "init"
    system bin"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}jj file list")
    assert_match "initial commit", shell_output("#{bin}jj log")

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end