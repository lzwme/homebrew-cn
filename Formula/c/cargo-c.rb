class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https:github.comlu-zerocargo-c"
  url "https:github.comlu-zerocargo-carchiverefstagsv0.10.2.tar.gz"
  sha256 "0217c26fee99f3af867ce52719a39349d19ec6cfac084eea3901f8046f4607c6"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd9fa62bcfb42fd0b4708cd67d47677864116ef7fd500c4bf590375a440f79ff"
    sha256 cellar: :any,                 arm64_ventura:  "08f8ca7499ad8e1cc9938b0d197924fa4b26e2a774bd698dc194d73426c92284"
    sha256 cellar: :any,                 arm64_monterey: "05e03fcc85dccfaa7c57c951d954dc41934056bb2dc056fd24f8d3a9ceec27a5"
    sha256 cellar: :any,                 sonoma:         "ac33123a71f8a727d6bb810b27130c43dc9580e99df914142d50fd51a48afc9a"
    sha256 cellar: :any,                 ventura:        "aa129258503fb6f6be647d5ed1e3a46f143c063472f7891d53dfce8af9354d9d"
    sha256 cellar: :any,                 monterey:       "479a68f12cb3b494507b60eb56e3f705ee216e5f117e9102cc013446f2349b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd506221f794844239b7d8b17cdf05f41b9b7e5bba4a4018d2294ccf47a1cde"
  end

  depends_on "rust" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
  depends_on "libgit2@1.7"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
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
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["curl"].opt_libshared_library("libcurl"),
      Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end