class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https:github.comlu-zerocargo-c"
  url "https:github.comlu-zerocargo-carchiverefstagsv0.10.2.tar.gz"
  sha256 "0217c26fee99f3af867ce52719a39349d19ec6cfac084eea3901f8046f4607c6"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "65bdfdbdd2fadaffa7403e827e7f8f70f9032a0649bf932b8795f830686f1f63"
    sha256 cellar: :any,                 arm64_ventura:  "05290ac98f8b3479a323647d03c017ad7c65436d79a265d8cc3cc959fc127322"
    sha256 cellar: :any,                 arm64_monterey: "84b51cbb3222f5b55b8fed9c5982492fc1296cba466b6d6fa3270369f5d51464"
    sha256 cellar: :any,                 sonoma:         "596bbe23e4d79f00a3552344c6c02c9ab847c64d364ddf208519aefbc44136dc"
    sha256 cellar: :any,                 ventura:        "9910697f72f1c0454eee15aee3ded8a128e5e5f54535b0671b869159aeec2a7d"
    sha256 cellar: :any,                 monterey:       "b269fe9610b92a6f11b86bebc1496d0309fd468e0a2a1be42302755c8c6d5f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e59b4239ae7f0141fd6807039e944856f6d0173feb0ebde24e47deac91a9dd"
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