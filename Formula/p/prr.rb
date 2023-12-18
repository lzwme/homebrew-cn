class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.11.0.tar.gz"
  sha256 "4f81770aa28661bb3cc880507ec9d56b46f8d26310acca1efcc6cc29571c0531"
  license "GPL-2.0-only"
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "566d97b538c2a086b12d78799da01d3f05b67fc1e1408010050c928f7b965ef9"
    sha256 cellar: :any,                 arm64_ventura:  "3303b91bfc4d51a7213133a96857ad2ddf4dd96312613a3d8984c5b5d649373b"
    sha256 cellar: :any,                 arm64_monterey: "ea8debd95622d22bda11d43c9253bafe3e2bacf90ed82bbf26eee89f5fa11360"
    sha256 cellar: :any,                 sonoma:         "60f5a66a5b975958734b8ec3ef8b79d6db6dded3472b0b22d118d4308be90f29"
    sha256 cellar: :any,                 ventura:        "3e1ce66c4112dac884b135b4d91d49d96328835e0701650c4e419aaed044653b"
    sha256 cellar: :any,                 monterey:       "41db3631a5f29b19d47a46e602a145e276dba1695c43a7671f13cb77da73f30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164b6962b332731db1f8d5c6099e39fc73c3358e68a3cee220786e60fffa582d"
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