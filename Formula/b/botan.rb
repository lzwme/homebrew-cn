class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https:botan.randombit.net"
  url "https:botan.randombit.netreleasesBotan-3.5.0.tar.xz"
  sha256 "67e8dae1ca2468d90de4e601c87d5f31ff492b38e8ab8bcbd02ddf7104ed8a9f"
  license "BSD-2-Clause"
  head "https:github.comrandombitbotan.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia:  "dc8310abe0f96336059827bcd80899a4587f7d497b20b55162fd087b07d3b05a"
    sha256 arm64_sonoma:   "aa11c6a304090b87202a5dc2ab82b9b82ac761d505cddfa168d741bfea2ce728"
    sha256 arm64_ventura:  "1c0262d4204807550d0d254d50239579e092c2fe2a3c605f0b18ca9460b199ab"
    sha256 arm64_monterey: "eddaaff629f4803ad72d0a9b1c4337123f1f7855c442b43d1827448a8d86bbb5"
    sha256 sonoma:         "5261549cf532913036283820da77d452cae2f549c3a61d924b7d988c64b7ad4b"
    sha256 ventura:        "cdfa44fa31c62afcd083b4b77e7bd032fd53bd7ec40dfa4d9ee5a266e65ace01"
    sha256 monterey:       "ae348e462be182f48e69f4182c59f883b55695c3052d4a21e4b9c73bdcb90f11"
    sha256 x86_64_linux:   "eaa76f947d74ac3cd9501dc86d600214f5876388ebfb3ef675254e167d4f062f"
  end

  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "python@3.12"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with gcc: "5"

  def python3
    which("python3.12")
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      --prefix=#{prefix}
      --docdir=sharedoc
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --system-cert-bundle=#{Formula["ca-certificates"].pkgetc}cert.pem
    ]
    args << "--with-commoncrypto" if OS.mac?

    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang

      ldflags = %W[-L#{Formula["llvm"].opt_lib}c++ -L#{Formula["llvm"].opt_lib} -lunwind]
      args << "--ldflags=#{ldflags.join(" ")}"
    end

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath"test.txt").write "Homebrew"
    (testpath"testout.txt").write shell_output("#{bin}botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}botan base64_dec testout.txt")
  end
end