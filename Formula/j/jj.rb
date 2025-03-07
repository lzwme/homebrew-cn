class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.comjj-vcsjj"
  url "https:github.comjj-vcsjjarchiverefstagsv0.27.0.tar.gz"
  sha256 "a9d2ab04698f971a215ae2510082d0bc00540188deb90d48e12e86a6d6a023af"
  license "Apache-2.0"
  head "https:github.comjj-vcsjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d0634c7e5d2d58395b669e17fd6216cd1b479d053c6939758944b5773cb4379"
    sha256 cellar: :any,                 arm64_sonoma:  "d274c267c3ee8e1e7c44118f02161f2aeb6edcaea36a2624efc68710e38bccb1"
    sha256 cellar: :any,                 arm64_ventura: "c0f83bf316cd23337defe87ebd3af29c79eb8c946440e945ae47ee4b0bdbac3a"
    sha256 cellar: :any,                 sonoma:        "5f68e6206a8b6ada72b5c775a28a6fa9b5537e07932cf73d2fb4c31a1c69f6ab"
    sha256 cellar: :any,                 ventura:       "ffc4619099fdd5a445efda8e5e00afeaec487e748ee63673321829b2ed6872cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff87d1f90bfbe3daf2a0566d661c73bb94d957019ca762fd02781160b23142db"
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