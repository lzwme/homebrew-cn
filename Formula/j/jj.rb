class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.comjj-vcsjj"
  url "https:github.comjj-vcsjjarchiverefstagsv0.26.0.tar.gz"
  sha256 "099eeb346f32a4968ebb8273566321eff2e6ca6a7de0c9dcfd7eee016b37cba1"
  license "Apache-2.0"
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7cd799ab79d243b5b5a4d6e7e76c8099c28b0611eaac75c4bb262ff92512db47"
    sha256 cellar: :any,                 arm64_sonoma:  "87ee2ec2eacd2a8776a81e16b32aa57490a3faa740973bfeb49239241674853b"
    sha256 cellar: :any,                 arm64_ventura: "0475f8f30621838eda92a15364ab044c870fb6535168d019b0edbc9dbe493e1d"
    sha256 cellar: :any,                 sonoma:        "0fca81f48667c8c017417f7a0a370b15175db25e52cd01332f384de358d5014e"
    sha256 cellar: :any,                 ventura:       "286c3273628ab71e4ac65fc18f10fdb55fbb0fe06af0a57f597800adacf7ef74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f83cfb4bd0cdec091d154063fb68aeb3af0a15c487d35b4fdc60ea79a5b2595"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # patch to use libgit2 1.9, upstream pr ref, https:github.comjj-vcsjjpull5315
  patch do
    url "https:github.comjj-vcsjjcommitb4f936ac302ee835aa274e4dd186b436781d5d2f.patch?full_index=1"
    sha256 "7b2f84de2c6bbdce9934384af2f7f2d0b7f7116c4726aeef87581010cdf1564e"
  end

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