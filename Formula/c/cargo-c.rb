class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https:github.comlu-zerocargo-c"
  url "https:github.comlu-zerocargo-carchiverefstagsv0.10.1.tar.gz"
  sha256 "0f08ef800bd2c46968356d9445ee780085fcbb500a2e8ac3447f2e4a9981e939"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a192546b54fa93a8450532428dad361b6ffb08d5704b7e7964ba9c1153e9120"
    sha256 cellar: :any,                 arm64_ventura:  "e2c1f42c152279cab368b8fbaa2397ab0eb336a11816f5a60b17ad2004f6b0e5"
    sha256 cellar: :any,                 arm64_monterey: "7b09aba80ede7d9474c32e5420c16c56362c138b657bb2bd0e3ca424b3d2363d"
    sha256 cellar: :any,                 sonoma:         "8765d399bd4d3dfd7c74599d62bf3639f2dda33bd2868153589a7a6932b1848c"
    sha256 cellar: :any,                 ventura:        "58daaa576944d3d80dfd68319f8eecb4f0732c94603ef182a8ac26f086b0283a"
    sha256 cellar: :any,                 monterey:       "2ca5c2003b44bd3f60f3002e1a00d1e4025c6168773f08d97c21f622c58f70c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a8c354e5ad3984546f08517d460066fb89e6004fedebfd575120b562950b317"
  end

  depends_on "rust" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
  depends_on "libgit2"
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end