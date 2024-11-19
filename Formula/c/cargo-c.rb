class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https:github.comlu-zerocargo-c"
  url "https:github.comlu-zerocargo-carchiverefstagsv0.10.5.tar.gz"
  sha256 "3f131a6a647851a617a87daaaf777a9e50817957be0af29806615613e98efc8a"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "8e9a3bae0da95a41d8818909c34ded22c2aba59a3a12d07b0389eef73985ed94"
    sha256 cellar: :any,                 arm64_sonoma:  "c476ff73e9228cdeab5fe42e4d9ca54bf01a641cd72bb9d3290bf120229b27d1"
    sha256 cellar: :any,                 arm64_ventura: "13be07e091401e2a1913d19b2876186fda87d7547bd5a67400a97c693334b428"
    sha256 cellar: :any,                 sonoma:        "22b3b8467d4d071bd79cc234cb5f513f3b5c1f93fec3a5f330172a468a50c283"
    sha256 cellar: :any,                 ventura:       "952068e034d29232358ce9747cc246cfa0371f1e08c15d2d0184428101a69a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b2f52bb385f560be363f7631bbc3c5bff0c8f70243ff0428bdb2c15ee163a2"
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