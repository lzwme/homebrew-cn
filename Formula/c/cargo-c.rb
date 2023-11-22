class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://ghproxy.com/https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.28.tar.gz"
  sha256 "f5237b057c8c6c21c2d3d827acea8a0a059db780c69e3eaf807ab3c43e50798d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8cb37545f395e018fcc2069562f701fdfd7e70445e8b2b8741e2ea5fcd5d509d"
    sha256 cellar: :any,                 arm64_ventura:  "f411065db9ad8f80fe58613282e97e8122a741a598148d3dd42ec31c7bcaa67a"
    sha256 cellar: :any,                 arm64_monterey: "7644f980d7bd7d55fce1eac7c0fb6afcc9d8c2bd6e885c76958db324b0558b4f"
    sha256 cellar: :any,                 sonoma:         "fa75d3084f19dbf25f2d36562187695bcf5fcb0ffa7b18fe9b88b8faeb92d48c"
    sha256 cellar: :any,                 ventura:        "2501499cb16e45f88c56fcddac76ebf1cbb8d01119ff0410daec88526b6f0f70"
    sha256 cellar: :any,                 monterey:       "93f5d68680b84560a83cc57cf1cbdf18c092e2b56b9964a8e3672729043c9bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23e4e5957aa5a83834883a963bc66584552252164c610bc39c9f4894e4639943"
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
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["curl"].opt_lib/shared_library("libcurl"),
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