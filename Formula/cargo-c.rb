class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://ghproxy.com/https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.22.tar.gz"
  sha256 "6af542e3d76e4341693b2e9a9f50abf15b04d82c5f9d1b350110cfac7e914e73"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98238b35a147e5982e786b9c0a6876791accdf2534c74e9fd4f80b57cf6ae6d7"
    sha256 cellar: :any,                 arm64_monterey: "d1e5323e129eea909b1681f7b60710eb911e3d1e8138f39a3605bad02fd5e487"
    sha256 cellar: :any,                 arm64_big_sur:  "440056f707350b6ed950e36bc1bb95b47ce2f26c560683800750e8904fc45006"
    sha256 cellar: :any,                 ventura:        "32c845d987a2b95c37378aa42196ecbda26e37df6cd364f23bb97f5a1b62b701"
    sha256 cellar: :any,                 monterey:       "f82dcafce74d96cdf27fb8c8dd37a696f9ca15f965563f175d2543531a81c6fc"
    sha256 cellar: :any,                 big_sur:        "5cb898294bb6efe71981c95bd6284fec8461ff47470aaa235e626192a89126a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ee34f9d0f91401c46135bc7011410bf2cd2f8c962d602b8ec05188d9d648fd"
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