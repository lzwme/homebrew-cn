class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https:github.comlu-zerocargo-c"
  url "https:github.comlu-zerocargo-carchiverefstagsv0.10.7.tar.gz"
  sha256 "c4532dd2bf23769df5f64649d5b0c037fb2a29467c74d16a54bad3054d9f3f3a"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5951973b69b0cb31e7ce329ea10ec1e079a623f41ff1a98f711c84798c1e42eb"
    sha256 cellar: :any,                 arm64_sonoma:  "9be9fcbaa46d8145277a02eeb086b70cfd227d1c5f8fd8bcb5fbf7038f78ad4d"
    sha256 cellar: :any,                 arm64_ventura: "814ef6637f5e55538275ff4e12e00c19f10b9931a00abfcc3bd924434a3f187d"
    sha256 cellar: :any,                 sonoma:        "bbeaf25cbfcfff7b2c2d24bf042e361ee2d7f75aeba4a06699abaf0d88145d6f"
    sha256 cellar: :any,                 ventura:       "5f48c342177b5ffe5653a601588ec3db7bec366df7aa1fd0173429b2fb242a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79ec2ac05df9f384a6c372610c7f995bd3f518f0d341eb53f1e5fa709f122f4e"
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