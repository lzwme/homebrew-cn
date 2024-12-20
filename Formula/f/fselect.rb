class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https:github.comjhspeterssonfselect"
  url "https:github.comjhspeterssonfselectarchiverefstags0.8.8.tar.gz"
  sha256 "0f586c3870a66d4a3ab7b92409dcf0f68a23bd8031ec0cc3f1622efebe190c9e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e5e7b20338ffee88d3d873a8833eebb899d178d664b69d9ec1467f183b83a7bd"
    sha256 cellar: :any,                 arm64_sonoma:  "4a7a59e06bdc9386a66ad1f321b8be70d9fd44311a1855847fae76ac76171fb9"
    sha256 cellar: :any,                 arm64_ventura: "9c69d01efd42573aec1830a943fc6e3e40027430529d6ad34d7fef9f2a983c17"
    sha256 cellar: :any,                 sonoma:        "067861bb6541a0cf74f7e5398bc77a2f17e7acda0c9ecb4fae662be738488dd2"
    sha256 cellar: :any,                 ventura:       "933cb9075ee0eedd71b1668a776806c66d559a5ad48f4d5428c7e976c8126ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bccfa74b105eecd9922f38cd7733cf940e6701ac2da1fb8c501775b160a63b5"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    touch testpath"test.txt"
    cmd = "#{bin}fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp

    linked_libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_libshared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end