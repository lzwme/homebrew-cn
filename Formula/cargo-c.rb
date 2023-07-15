class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://ghproxy.com/https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.21.tar.gz"
  sha256 "fbc199ca7da0514d18200a19630a9bbce6f4d5871c9c3ca5f0b6bca42ee99095"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6542b64cba1967af59c045feaef4a41bcb15992963864cadc3b0de01c66bb7b5"
    sha256 cellar: :any,                 arm64_monterey: "fa2bf0112b5527ebfba5047f6ffabebae3ad9aa9cff4d94b807ca8bdf264bc40"
    sha256 cellar: :any,                 arm64_big_sur:  "d4d095d0270b49f832694f273acc5eea2f2ce9ccd886bdf4c73936a02f5a6ac5"
    sha256 cellar: :any,                 ventura:        "68ee2fe819ef3ff6f4ecb400af07d0c1289d534323c59f4cf5e1031c9d5475b0"
    sha256 cellar: :any,                 monterey:       "2f55a87b8f8b61986ff257c41d9ff527cde649ce28b9a9487eadfddab9f9cf80"
    sha256 cellar: :any,                 big_sur:        "46224935b7318b09e32dfba60af0dbb416cfeb0c6ad62b9e5d531cbe9140e8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e50d6961ee0a6d2fd923e15eef6d536695182509652b8e4bd74f64abfec909"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
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
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end