class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://ghproxy.com/https://github.com/lu-zero/cargo-c/archive/v0.9.16.tar.gz"
  sha256 "a84e31fa1718db05f0c7708aff0688858362113d35828e0bc478199b5761256f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b452870a06a79ffda6ec7b60f3d760bc0cb067c9422c219ce705527ec5d444d3"
    sha256 cellar: :any,                 arm64_monterey: "b53172ed73cc4268613f9870343ab6ab7ee96641a7b57b81844b872bb2c0e83c"
    sha256 cellar: :any,                 arm64_big_sur:  "56108ebba57f6c567d5d9b7140e2bc55aea825490245087a4ba66d3ee4d6fc67"
    sha256 cellar: :any,                 ventura:        "265efbdde7578b23e7367217bd55be2e4c6dc7a3cdc91eeed926654f35ce1a1a"
    sha256 cellar: :any,                 monterey:       "957df28bb398d7b90414705aeeae0a6f44034e79a0b4486b7d9b94511192d276"
    sha256 cellar: :any,                 big_sur:        "1d6005dad67847e1305cce8eb6360c3ec7de27a46e56afe83fdbc9e7ba244231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099581139fd30570ba857941c20c264c722c330848097237d4c4f4bbb905d853"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
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
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end