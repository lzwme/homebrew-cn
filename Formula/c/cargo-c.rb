class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://ghproxy.com/https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.24.tar.gz"
  sha256 "32f2f5c802c01c51cf93471fcf876d0cc68edbc31d22005b9f07e4549d5b98b1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b1b5e38f22b653bda2c09f832ab77cd121176dacb921edc920edabcfd88fdc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "760ec61ae2e70b6611e2e0b123c777f43eaa073ddb67780db1358993db4fe251"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dca5bd81528ebd986254916ccf066d8ba00ae0d9431f2d65a483594509d838d"
    sha256 cellar: :any_skip_relocation, ventura:        "5a3e1149969faeece9003d3bbc231be9ad76b18b46d62a6d52634e48b5748ba2"
    sha256 cellar: :any_skip_relocation, monterey:       "243a8cf2ed7f17b96c5e1c5152ab6ce19aae4fc13b3b019a16e0694918e5628a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a31180a118ad896265b0d73b29c4f997fc3342e78b21361212adf9dd2bc7c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff80138b83fd476139cc6a14228a81734cb7de0c3e855b8eba3e4c96a9f295e3"
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