class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.19.0.tar.gz"
  sha256 "76d101fefe42456d0c18a64e6f57b9d3a84baaecaf1e3a5e94b93657a6773c11"
  license "GPL-2.0-only"
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d51ff33fe7be93b0e1c9d1ec9d5b86792d68c59cf1bd43fb61a8cdf88a4391b"
    sha256 cellar: :any,                 arm64_sonoma:  "5a217d0b50c1169f3526faf7c04c8d871cb2795097234635de65aab5287d126f"
    sha256 cellar: :any,                 arm64_ventura: "00fbe685b7669440fd8752c4622a125646196a35ac4fd6b13f5b289e5785b1e8"
    sha256 cellar: :any,                 sonoma:        "7818bb0712e26930334fb9777ad7cd295092c3f7f3cbd77ffaf0ef0033940877"
    sha256 cellar: :any,                 ventura:       "d2c4c34d50b30f461ae9ffd77515b750499fafe62b66e0efee1ea2d33a8c78ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "867d5a7dee57560d17126ff0892654a8a55e7a26036d17bfedbf0e5bdc1070fb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https:docs.rsopenssllatestopenssl#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}prr get Homebrewhomebrew-core6 2>&1", 1)

    [
      Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end