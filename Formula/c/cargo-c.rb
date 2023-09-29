class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://ghproxy.com/https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.24.tar.gz"
  sha256 "32f2f5c802c01c51cf93471fcf876d0cc68edbc31d22005b9f07e4549d5b98b1"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "86d415e4a05c2a5f90814fbd0ac0777e5a1b8f238152f467ec402d2da920d195"
    sha256 cellar: :any,                 arm64_ventura:  "589237815e98e8153e0f07756b3facda654709f41fdd965659b288e21f36debf"
    sha256 cellar: :any,                 arm64_monterey: "49ffc9d696d22126a8693fd0c4ff17bbed02d5e7e6bbe053eec7b688e747da1e"
    sha256 cellar: :any,                 sonoma:         "b0f5460081190e1437ed25c7da27e561ac9d8f178af36c2b92bf361f976d0f43"
    sha256 cellar: :any,                 ventura:        "78e679ffb75f32018c0d8b336f0e2339eba35c9548a21ee644bc70f771e82d48"
    sha256 cellar: :any,                 monterey:       "b53c7647b9e3ba696ffca03e707a4386a58a9187ea9c9e4a1e26228c635164e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2197e9e20ac20ae234ece76446069613bc39ee9a2c41ef8c3adb58129a307d1"
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