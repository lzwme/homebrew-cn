class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https:botan.randombit.net"
  url "https:botan.randombit.netreleasesBotan-3.6.0.tar.xz"
  sha256 "e6ec54a58c96914d7ce560f17a9a5659ebb987e053323bb9ca2bffeb90707e7a"
  license "BSD-2-Clause"
  head "https:github.comrandombitbotan.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "674ae869fb81ee8b6e53afe7b1c586256206257a0f7d77d790fb09798bda1c00"
    sha256 arm64_sonoma:  "04e7d1dfab36e4ae611af7d5eb6a5208905cbd5cd6ea1f19c6c72c2c0b934002"
    sha256 arm64_ventura: "e0019720d9cd50382aa10a0e1edc921dba1ca0d3c62636a20c0fb88c34bb4852"
    sha256 sonoma:        "d9bf7e33b356fcb5ec17b23cab3d23c890008e31e8a000b0e1fb3998c22f7e1c"
    sha256 ventura:       "f89f01935eac85c8fb40cf4bd0050205f85d51c681bb15ceddfa0af65743e36a"
    sha256 x86_64_linux:  "d87a0cfcc31d3b0dadab68b1b27d5166f6d0712465cbe44a2ded9134f3f81a66"
  end

  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "python@3.13"
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
    which("python3.13")
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