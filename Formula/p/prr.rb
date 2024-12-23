class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.19.0.tar.gz"
  sha256 "76d101fefe42456d0c18a64e6f57b9d3a84baaecaf1e3a5e94b93657a6773c11"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f634382fcb02db3ba4d30894e994117cd8a38ebbd8c59bd19caa86e865a38e65"
    sha256 cellar: :any,                 arm64_sonoma:  "7e64bdd9af0fa0502337cec76811263226351e59859b91011d3cafee34a0bbcc"
    sha256 cellar: :any,                 arm64_ventura: "f1eb7e059742c7150f6233c07251ef1919f46b2bd19ca9189233b85616849419"
    sha256 cellar: :any,                 sonoma:        "4aee5a6c4ba227554e7d2a1fe8ed25b3d9eb1969f3456f1d3e575410dbcb1dc3"
    sha256 cellar: :any,                 ventura:       "dc6bfa37161a2fc3764ceddd17af3f78a67e879ec3bbc27480fd281f207f5025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9932fc8ab7379376270cd927e2aa981c080ddcaf105672ddf64a4ceb54bc9142"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # support libgit2 1.8, upstream pr ref, https:github.comMitMarogit-interactive-rebase-toolpull948
  patch do
    url "https:github.comdanobiprrcommitc860f3d29c3607b10885e6526bea4cfd242815b5.patch?full_index=1"
    sha256 "208bbbdf4358f98c01b567146d0da2d1717caa53e4d2e5ea55ae29f5adaaaae2"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https:docs.rsopenssllatestopenssl#manual
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