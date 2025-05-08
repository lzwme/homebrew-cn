class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https:botan.randombit.net"
  url "https:botan.randombit.netreleasesBotan-3.8.1.tar.xz"
  sha256 "b039681d4b861a2f5853746d8ba806f553e23869ed72d89edbfa3c3dbfa17e68"
  license "BSD-2-Clause"
  head "https:github.comrandombitbotan.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "0d1f589f900dc679b34940bf606a016e015ed922a5f759b9daadbd9b8969c1ae"
    sha256 arm64_sonoma:  "751910a74fe11ed9d3b8b3abf79aae11036b92f9875fd0475d13294d92dcf49c"
    sha256 arm64_ventura: "466dbfcd5eaff897ea903b82d6ecf680f1159c28087e6621760f0f29c96805cf"
    sha256 sonoma:        "1d91396c3dd3462bd6c770c75e65add1b924f97c21d66d8448abbe24906588a9"
    sha256 ventura:       "38149c11397d68a6e7671dd3efd73922357105e29f8a68ef7d6652e293293d80"
    sha256 arm64_linux:   "0a7614e14b1aaa075695bc05185c789f48b8deec3d431288fd547f10f53f4fa1"
    sha256 x86_64_linux:  "2b8a84de394ad2ecc64249091c0f4ccc23521a4b33ff70b693480a5731271454"
  end

  depends_on "pkgconf" => :build
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