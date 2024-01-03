class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.15.0.tar.gz"
  sha256 "b7e8feea2fb01e131ac996b37a276c46a0feadbd0eb5d856da6717d76cd4fd75"
  license "GPL-2.0-only"
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74ac445380c178d428221bb1d593a99ff78823bcf8dba8b86aded5356d354cbd"
    sha256 cellar: :any,                 arm64_ventura:  "967a0d33a5c854b03a32d8dd0d738c0224327290aa478a4aaee5e95f88eaf274"
    sha256 cellar: :any,                 arm64_monterey: "05a3cb1b93064211c0c8c6bb78003efd6703c0fefee48b749fc9c57c97a794cd"
    sha256 cellar: :any,                 sonoma:         "5be6aa63af3bf98432acb2c0e9528c4eb882261c3abb6ce7771edc7e03972cae"
    sha256 cellar: :any,                 ventura:        "b38038ad803d131c91e0a8af94224cee49a6201f5a7bd3cfd50f8ff8b2bdc391"
    sha256 cellar: :any,                 monterey:       "599ff18cd646eae625f800fae11e535719f987fd7619258f7b7b832c598910d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3343399b00e752d46eb4940c57e18b5142f3386a735bd8e928ee7f2a119d4696"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end