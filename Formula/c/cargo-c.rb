class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://ghproxy.com/https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.26.tar.gz"
  sha256 "6101c4f1d6b17f6b42982dd908f194493e966a91d5a3cf9c210c65dbf66683b3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2451c5384b5a757f6498e41fc9e3ba47c42d3c82f4a1ff3cd5245fa865dbd714"
    sha256 cellar: :any,                 arm64_ventura:  "009077796236e98b6c36f3646defd3f8f33a7c991a87e46434bdd742851bd300"
    sha256 cellar: :any,                 arm64_monterey: "b413d80a44b85fb1762bdbfdad17b9601ad78f6085c3222d2aa438351c220b7b"
    sha256 cellar: :any,                 sonoma:         "bafb5fa8c7c3456d93d83ffca784ee314b49741895d9e7df78bc837b8afd9002"
    sha256 cellar: :any,                 ventura:        "e6e2948fdbd0403997559fafece6397620bd0d369ea1295674e8617da5831dae"
    sha256 cellar: :any,                 monterey:       "42032c5bb65260b93bd26954f8dae4d186f1363c359d8d713ddab2356927f3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2638f2f5150d78cb06765ffbd4b198bc369901e320106b9d16b8676bd037f371"
  end

  depends_on "rust" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
  # To check for `libgit2` version:
  # 1. Check for `cargo` version at https://github.com/lu-zero/cargo-c/blob/v#{version}/Cargo.toml
  # 2. Search for `libgit2-sys` version at https://github.com/rust-lang/cargo/blob/#{cargo_version}/Cargo.lock
  # 3. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Use the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
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
      Formula["curl"].opt_lib/shared_library("libcurl"),
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end