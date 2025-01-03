class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https:github.comjhspeterssonfselect"
  url "https:github.comjhspeterssonfselectarchiverefstags0.8.8.tar.gz"
  sha256 "0f586c3870a66d4a3ab7b92409dcf0f68a23bd8031ec0cc3f1622efebe190c9e"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9312998702ee83c806f9b8a81680b134a5b0673de1bfcb19e0d3e623e9c05fcf"
    sha256 cellar: :any,                 arm64_sonoma:  "aee99ad575ad0ee51b8da39d8b5eec8ed8c996d05a07a6906cadeadbf43da820"
    sha256 cellar: :any,                 arm64_ventura: "5f3dd57481b735dac9c15672fac8ade8e4849b3c8b2f2e0ec5d68e19d72f09b5"
    sha256 cellar: :any,                 sonoma:        "064482d661067674ac21273e77738d3967d85fceb9035d171afb70b020166b43"
    sha256 cellar: :any,                 ventura:       "3088a497579df2acbfb99951d22a91b20fb4bfa093a7a92a680cc2fb54cd5440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1978401b8eeaad13e973afdb08633715c9b517da32428ae40fcac426bc56c5a0"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
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