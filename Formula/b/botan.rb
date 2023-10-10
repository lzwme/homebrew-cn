class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.2.0.tar.xz"
  sha256 "049c847835fcf6ef3a9e206b33de05dd38999c325e247482772a5598d9e5ece3"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5b5aaf3399bd8f4e1243e4bd84b1141a2982467614de2ca27d032776c8671178"
    sha256 arm64_ventura:  "27cb6e286d41941376432b1ba2cc18e3ff2ee0cd5da1f067cec38d206dbd8c87"
    sha256 arm64_monterey: "6ec5ac701a92b70cda89a089a441a98006591f03a05b06de6bf098f09214baa5"
    sha256 sonoma:         "9d5e6464ce94f27758d23d0f67159bcf94a1f863af77a9739c05145812534187"
    sha256 ventura:        "da25547f83de1be3ba5f4d6a283183c5678734d7f8522c5389f49dd2993e58ac"
    sha256 monterey:       "3d5ef686c6dd72828ad97543c863acd3d302d0263c9b061c3a3400ac285b1b67"
    sha256 x86_64_linux:   "467b74671ed4e22502cbea46d64eb709f72df01c5c46aef2bc9a18366331ff3b"
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