class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://codeberg.org/maandree/libkeccak"
  url "https://codeberg.org/maandree/libkeccak/archive/1.4.1.tar.gz"
  sha256 "d7b9b9e8da629a80356ce2516c2003e2d46d3ed7a3c3178ba1f89bf1ec8e5fc3"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d2789a7559a35c28efead797077b31cb6bc0d7d8a34bec98a7c0ffbafe0c2cd"
    sha256 cellar: :any,                 arm64_sonoma:  "3afd0eda437e5ae52bc5431a993291724462e982169db868e9e4f3137147ebd2"
    sha256 cellar: :any,                 arm64_ventura: "cd2787eaf814ded617723ef57cde7272b6a0bf045e91c3dddd76f17f0da5c5de"
    sha256 cellar: :any,                 sonoma:        "6bc4e81b10efb0680d679751bdd02db3cd93f289e3c56e0a411d0ce5d243254f"
    sha256 cellar: :any,                 ventura:       "8269136615b749cc7a7de231bbd0a0ef05b2bb1154e5a60595db61b38a5855d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5d1d1369bc27861a72fef93c08dfa3d4018629739083124e526922033fc586"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    args << "OSCONFIGFILE=macos.mk" if OS.mac?

    system "make", "install", *args
    pkgshare.install %w[.testfile test.c]
  end

  test do
    cp_r pkgshare/".testfile", testpath
    system ENV.cc, pkgshare/"test.c", "-std=c99", "-O3", "-I#{include}", "-L#{lib}", "-lkeccak", "-o", "test"
    system "./test"
  end
end