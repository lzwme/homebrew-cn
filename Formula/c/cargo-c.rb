class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https:github.comlu-zerocargo-c"
  url "https:github.comlu-zerocargo-carchiverefstagsv0.10.7.tar.gz"
  sha256 "c4532dd2bf23769df5f64649d5b0c037fb2a29467c74d16a54bad3054d9f3f3a"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8aec96a2dce142fbe7f95ab307f1db7b97461e8015883540ff5e3f1ea81e87d2"
    sha256 cellar: :any,                 arm64_sonoma:  "d35a8a6e883a1c24edaae1859c95538203949b37797ba889d86f0ede922ed70b"
    sha256 cellar: :any,                 arm64_ventura: "472d2114a047824e76ad513d80091d232b88409ca5e55a893a48cc5614efd2c1"
    sha256 cellar: :any,                 sonoma:        "af9bcc231409f9459314350d12028555f625952dabe4959fe6fe408cf83a421e"
    sha256 cellar: :any,                 ventura:       "09f6635f2e7d963d798d1229508d2cf3ce98a067c666586889a4c3bce5aa51d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a65e5792a0cef75b7fe70f1bf738b752d6cac6798e108a87441b67b50ff39fe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end