class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https:github.comjhspeterssonfselect"
  url "https:github.comjhspeterssonfselectarchiverefstags0.8.8.tar.gz"
  sha256 "0f586c3870a66d4a3ab7b92409dcf0f68a23bd8031ec0cc3f1622efebe190c9e"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d46f7a11a969a0834c8df0f05ab418edefe5c060b6d83ebfadd6bc8208097cc8"
    sha256 cellar: :any,                 arm64_sonoma:  "fb9c9ab8540eb5bea59b2628ecc1b7cd7f443cced29a4f4d4980da28d52eacb2"
    sha256 cellar: :any,                 arm64_ventura: "a6d21976498388e1aa0b8e1576c38da9bd0b2d4e2388f351494e6db45d17f419"
    sha256 cellar: :any,                 sonoma:        "c6faa7e35e104b9d91cdaefa1afd52d611db3be3068f1281a5503373be39aed2"
    sha256 cellar: :any,                 ventura:       "f021952fe39663d1bdb48c8527b1880a41aa8e3e4da3d8e14d25787fa8c49dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59bfbff90e894ee8c08e6cd6d2169ece13458897af3cac07ac70be545d0a43f1"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # libgit2 1.9 build patch
  patch :DATA

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

__END__
diff --git aCargo.lock bCargo.lock
index 1df37fd..3845112 100644
--- aCargo.lock
+++ bCargo.lock
@@ -650,9 +650,9 @@ checksum = "07e28edb80900c19c28f1072f2e8aeca7fa06b23cd4169cefe1af5aa3260783f"
 
 [[package]]
 name = "git2"
-version = "0.19.0"
+version = "0.20.0"
 source = "registry+https:github.comrust-langcrates.io-index"
-checksum = "b903b73e45dc0c6c596f2d37eccece7c1c8bb6e4407b001096387c63d0d93724"
+checksum = "3fda788993cc341f69012feba8bf45c0ba4f3291fcc08e214b4d5a7332d88aff"
 dependencies = [
  "bitflags 2.6.0",
  "libc",
@@ -1074,9 +1074,9 @@ checksum = "5aaeb2981e0606ca11d79718f8bb01164f1d6ed75080182d3abf017e6d244b6d"
 
 [[package]]
 name = "libgit2-sys"
-version = "0.17.0+1.8.1"
+version = "0.18.0+1.9.0"
 source = "registry+https:github.comrust-langcrates.io-index"
-checksum = "10472326a8a6477c3c20a64547b0059e4b0d086869eee31e6d7da728a8eb7224"
+checksum = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec"
 dependencies = [
  "cc",
  "libc",
diff --git aCargo.toml bCargo.toml
index ff8c0f0..abb5a71 100644
--- aCargo.toml
+++ bCargo.toml
@@ -23,7 +23,7 @@ chrono = "0.4"
 chrono-english = "0.1"
 csv = "1.0"
 directories = "5.0"
-git2 = "0.19.0"
+git2 = "0.20.0"
 human-time = "0.1.6"
 humansize = "2.0"
 imagesize = "0.13"