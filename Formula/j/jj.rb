class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.comjj-vcsjj"
  url "https:github.comjj-vcsjjarchiverefstagsv0.25.0.tar.gz"
  sha256 "3a99528539e414a3373f24eb46a0f153d4e52f7035bb06df47bd317a19912ea3"
  license "Apache-2.0"
  revision 2
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3a956a8e62358766302d59d592f6555fe9a97173c1dd9143534172ff6ba0e9f"
    sha256 cellar: :any,                 arm64_sonoma:  "420d66af2270b1c3c5f6fae781537ebd0dbacd0d61f5cdd8ed6db77ca527989c"
    sha256 cellar: :any,                 arm64_ventura: "6dc19cc8fbfd30e51b4d17eec7ee08559f01cdb9719128d026e07ba92830d1c6"
    sha256 cellar: :any,                 sonoma:        "fdba90d9cbfa97802c6650f5007744e40ebbedd9e514688ac7fc5a0db614ea6f"
    sha256 cellar: :any,                 ventura:       "1ac2997276b2d2b4f39ca0423df4a117736016554ad59e26bb607041f2bd2b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d7cd0534b257658bb96ad207550a7f09e045ac3f4a3fb5e4e3771af49be3416"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  # patch to use libgit2 1.9, upstream pr ref, https:github.comjj-vcsjjpull5315
  patch do
    url "https:github.comjj-vcsjjcommitb4f936ac302ee835aa274e4dd186b436781d5d2f.patch?full_index=1"
    sha256 "7b2f84de2c6bbdce9934384af2f7f2d0b7f7116c4726aeef87581010cdf1564e"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"jj", shell_parameter_format: :clap)

    (man1"jj.1").write Utils.safe_popen_read(bin"jj", "util", "mangen")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"jj", "init", "--git"
    assert_predicate testpath".jj", :exist?

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end