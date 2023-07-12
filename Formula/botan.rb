class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.1.0.tar.xz"
  sha256 "4e18e755a8bbc6bf96fac916fbf072ecd06740c72a72017c27162e4c0b4725fe"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1085cd047023fd73d29138cdd697609c4fa3d19210f0eaa8d3151e6bc389a86d"
    sha256 arm64_monterey: "d6c06fc9dbec91ab45c85aab952a626b40964258dc11e19803b079b019d3de59"
    sha256 arm64_big_sur:  "2bfd1766930ffcccfb32840d4abb6820462988859fd23e47b9f75aef31883e27"
    sha256 ventura:        "352c35c4d7669538fbceaadd5f96d64f6f83d4ca9d1a0908a3a894b01636eb66"
    sha256 monterey:       "b55f4960e546a0ddeab12e7a7e51a34de44385214e168074ac52a61878e15eff"
    sha256 big_sur:        "a26401aaaa7776df9ce228ed82db7df538083e641b0f13edb80aff9cd129e677"
    sha256 x86_64_linux:   "39a781a830af5efaaf0a8cd51652e97705cac4142855f82608389e921a3f0b71"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1315
  end

  fails_with :clang do
    build 1315
    cause "requires Xcode 13.3"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1315

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
    ]

    system "python3.11", "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end