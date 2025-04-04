class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.comjj-vcsjj"
  url "https:github.comjj-vcsjjarchiverefstagsv0.28.0.tar.gz"
  sha256 "5560d7cef3bf6322aca7a9e34e61e757871da46585fcbd02661c376682d36548"
  license "Apache-2.0"
  head "https:github.comjj-vcsjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de921ad4061fb43039a4bba24b21e1f2429cf2f8ddac8a99ef763f6186bcf128"
    sha256 cellar: :any,                 arm64_sonoma:  "6005f26399d7e85860e6bfcc5e25ba76f05cfb9990a98ddd7244e21579d170b5"
    sha256 cellar: :any,                 arm64_ventura: "b382f102a1b8c8fb7f4b387e9e792fc96bd320386887bdea049e0e3337d24481"
    sha256 cellar: :any,                 sonoma:        "ba465edf93dd5121535d33d04cbdfe2c6ee6cd4649712b5778d89e1244463bb3"
    sha256 cellar: :any,                 ventura:       "d939ee5882f905e0834fc373033e7b6d3dea7afb5e134b042317ee1b89b01386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f23264911c8e3e631ce2755e3d5108117f6c9026cfe698989c0d6fd98cf76578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0e5a50d75a002fcb37d506100ea541671bd6bd14d9736f30e652753e65f5f5"
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