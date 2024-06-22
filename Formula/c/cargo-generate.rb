class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https:github.comcargo-generatecargo-generate"
  url "https:github.comcargo-generatecargo-generatearchiverefstagsv0.21.1.tar.gz"
  sha256 "3159eb16de57e0b28af67fcda01bcd54eee81edfbfd882e557018e4bcf6f41b0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcargo-generatecargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "662fefeb07f8f1736539ed3d169afed488e0e73f884ce3842766d4a9f0970883"
    sha256 cellar: :any,                 arm64_ventura:  "a1bb56e4b66027725544cace4cf19ce8905e2c5afae9afd4015f5c6d99c1585c"
    sha256 cellar: :any,                 arm64_monterey: "2f68946c691b2d9eea90006dd5dc59978d75f97086a3ec3a3253c95ce385ef96"
    sha256 cellar: :any,                 sonoma:         "61154a0cfe9d087e4cb80051da65ec908dff0783d48dba159b722fe8b2afc536"
    sha256 cellar: :any,                 ventura:        "d8d5b0f86ee7fbc04ba52e7f94dbf606151147d21c325d10a40b67297958e0e9"
    sha256 cellar: :any,                 monterey:       "bb1dab7e4944196149038c2d9bb17f8059c4539fc80306b9f33e4129c7a1ba4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64c4935df4ffdd8dfff0a508c23835600d5a999844f2f7fc3af9ca267fb3c34"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}cargo-generate gen --list-favorites")

    system bin"cargo-generate", "gen", "--git", "https:github.comashleygwilliamswasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath"brewtest", :exist?
    assert_match "brewtest", (testpath"brewtestCargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_libshared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end