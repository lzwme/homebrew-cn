class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https:github.comlu-zerocargo-c"
  url "https:github.comlu-zerocargo-carchiverefstagsv0.10.6.tar.gz"
  sha256 "60bc2b8936c16b456874bf12d29085e14e7df7010dfd10b798ee29807dde3b98"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "39bc53b10579a328785ee19e021930600ae0049d169f0319a8383b6ac1c43321"
    sha256 cellar: :any,                 arm64_sonoma:  "bfb69563997308c2400ed13ff4310df5e4019dbd5e17c067177c5eaeeae1d511"
    sha256 cellar: :any,                 arm64_ventura: "4c68826877722b2009213522f39ba99e1f97fb318177b6d1172893ba039e9dcb"
    sha256 cellar: :any,                 sonoma:        "0d26e434289b613e35938b23ed80fca8aee95f7586ca0a1e074ca5ec68ee5303"
    sha256 cellar: :any,                 ventura:       "e51a579906d5b524d1bcef98616150df3c199f7eb67098014c0366b90368c80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49996692870e395aa3c3de3e7dba429b19cd7d2d883a2ee31ddfe5b4a67ba5a2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https:github.comHomebrewhomebrew-corepull197727
  uses_from_macos "curl", since: :sonoma
  uses_from_macos "zlib"

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