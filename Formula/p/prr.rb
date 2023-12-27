class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.13.0.tar.gz"
  sha256 "e4c2c4c5bbbeefc21b41c7da9b3db67c365569da557cd85dd6cce29038021104"
  license "GPL-2.0-only"
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a3b320707ab8f123995c729413df14bd6bd6803aa2e8a29d5d2d1d5b67408f6"
    sha256 cellar: :any,                 arm64_ventura:  "bcb185709a0eee28385be357c1113d9ad3049ae032e40f5bae6476af007ed191"
    sha256 cellar: :any,                 arm64_monterey: "ff80a2c1c57e1a78989fac745527b8480b35bdf7f3f953443b43deac4a717d53"
    sha256 cellar: :any,                 sonoma:         "ca4fd2cbb70c59746042afedcec12f81f42c98e58a4b4b653fb5a1d21e77b17e"
    sha256 cellar: :any,                 ventura:        "64b8a6b8ec7ba547087cccdc0981aed5b47a7568893a90c42a6e147ae7794f6c"
    sha256 cellar: :any,                 monterey:       "9cfed40e0b2871a94de1b5b0cdd1cc40dc9cb526be55b9de334da641ddefc4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c054a089c9da05393c1ad5ee7dc3b6d8b56d62553dfc5e499b78bae65d6f0388"
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