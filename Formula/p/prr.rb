class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.12.0.tar.gz"
  sha256 "7a7ad312422e696d830ca217048ba106a7964690d5b25d06420afd85116b6c28"
  license "GPL-2.0-only"
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5313f1596a48c4183c058eea0892bb355a3a29acf6e3e510ceb7db5fa838c2c9"
    sha256 cellar: :any,                 arm64_ventura:  "69b31dba52170a3d15e0d9d97e0569e8c9141fdc9ecc531b9cb37ea7dc4522ef"
    sha256 cellar: :any,                 arm64_monterey: "6ffc3e81ba63fdd9d66f1f98ed2c66fd0099dede3327ef2145e95211ef61efce"
    sha256 cellar: :any,                 sonoma:         "57fe1a2f7fbba5c1a7f0fac35f11904af4091108abe0ab75d250f1b650cc7e5c"
    sha256 cellar: :any,                 ventura:        "f18faa4e2798eb884e7404c2eea2ec777e4228cb1f414717337645690d94661c"
    sha256 cellar: :any,                 monterey:       "7a0dfecbec41475d941973f90141ebb8388b1f725200f3572c8a85e10c45e72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f266830a3283a16285d233fff4661e64db28be8565957a5e1e4386de6b1e282"
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