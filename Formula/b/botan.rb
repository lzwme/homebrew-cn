class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.9.0.tar.xz"
  sha256 "8c3f284b58ddd42e8e43e9fa86a7129d87ea7c3f776a80d3da63ec20722b0883"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "20b605d280d09825a7359ba1efd0dda1bbd5e46aa43f810b2d6d484fdaa4bad0"
    sha256 arm64_sequoia: "ad63b78c79ad1a173c3969852bcfc2e607409da2db79392fb7b1e04c5772b8e4"
    sha256 arm64_sonoma:  "251d049d01a4800f9d3293dc6036fef0dd956428d8163b33d801aa05c91ad19c"
    sha256 sonoma:        "2d5c2cbf49ca883571de31e78527f8e594e86ee56f1fe734bdc93e11438972ed"
    sha256 arm64_linux:   "2694b54f044bbcc363bc16f9811d7c36d43ed248b186e9a8725bc4b7c4d7b788"
    sha256 x86_64_linux:  "97dc2d75dfad93dd6a701f2e56b81f3b25d8aa86262073371a407fa53cb0891c"
  end

  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "python@3.14"
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

  def python3
    which("python3.14")
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --system-cert-bundle=#{Formula["ca-certificates"].pkgetc}/cert.pem
    ]
    args << "--with-commoncrypto" if OS.mac?

    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang

      ldflags = %W[-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib}/unwind -lunwind]
      args << "--ldflags=#{ldflags.join(" ")}"
    end

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    text = "Homebrew"
    base64_enc = pipe_output("#{bin}/botan base64_enc -", text)
    refute_empty base64_enc
    assert_equal text, pipe_output("#{bin}/botan base64_dec -", base64_enc).chomp
  end
end