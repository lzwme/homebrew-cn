class Ol < Formula
  desc "Purely functional dialect of Lisp"
  homepage "https:yuriy-chumak.github.iool"
  url "https:github.comyuriy-chumakolarchiverefstags2.6.tar.gz"
  sha256 "c5506de4005a63039dc96962322ae94bf6c33eeaf63dcc03b07b1e8cc3a4d8f3"
  license any_of: ["LGPL-3.0-or-later", "MIT"]
  head "https:github.comyuriy-chumakol.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "5a9e307abff85e27d842ad8de7f9ce281a037386154a7c39a0e8a57b3d378504"
    sha256 arm64_sonoma:  "6758faddc2a7dbc71e03f881bccf6ee4f5534a75c0d19a2ec9cc875668219831"
    sha256 arm64_ventura: "6ccc4d40970b7514955cdb20db58682cb9dd0709ef467b4119f972869719c0f0"
    sha256 sonoma:        "519d8844f56b85f889046669676152e1323917320cca387da378f46238e0c29f"
    sha256 ventura:       "834d6d963775f098ec7ab3ab46e5438bc2bc42a0d70b9d74f2008fe1d457ef0b"
    sha256 x86_64_linux:  "0e38d0ccd5f4c27ee8044aa0be305b1bff4c506efc79b9d6a1abf2cebcb7db16"
  end

  uses_from_macos "vim" => :build # for xxd

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"gcd.ol").write <<~LISP
      (print (gcd 1071 1029))
    LISP
    assert_equal "21", shell_output("#{bin}ol gcd.ol").strip
  end
end