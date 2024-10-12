class BotanAT2 < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https:botan.randombit.net"
  url "https:botan.randombit.netreleasesBotan-2.19.5.tar.xz"
  sha256 "dfeea0e0a6f26d6724c4af01da9a7b88487adb2d81ba7c72fcaf52db522c9ad4"
  license "BSD-2-Clause"
  head "https:github.comrandombitbotan.git", branch: "release-2"

  livecheck do
    url :homepage
    regex(href=.*?Botan[._-]v?(2(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "1104641a2c34fa2c1212ad9002fc1a2089a75be4c9fb66ad655a1680c8428ad0"
    sha256 arm64_sonoma:  "c65820f897ce8748cc5b74e9537a7bcbc4842f161f36557f5b6858b409b32c63"
    sha256 arm64_ventura: "31a49478cd103522bee1b3e216145c3ba149f93e586a824b9d1b4ed4a2a196ae"
    sha256 sonoma:        "2bb57c57173cd293cc738dda60c02bcd2d7ddffad9f6e5d0b170245c03feaeff"
    sha256 ventura:       "51ecbd410373905c81df9ab8cf43b39076c77d255bd00e797a09c0a8243422bd"
    sha256 x86_64_linux:  "9fd91b5d569739ca97a8130d374d0d289a1d5f6a4b7e9cea90014ec714b52181"
  end

  keg_only :versioned_formula

  # Botan2 is currently scheduled to reach end of life at the end of 2024
  # Ref: https:botan.randombit.net#releases
  deprecate! date: "2024-12-31", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python@3.13"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def python3
    which("python3.13")
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=sharedoc
      --with-zlib
      --with-bzip2
      --with-sqlite3
    ]

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath"test.txt").write "Homebrew"
    (testpath"testout.txt").write shell_output("#{bin}botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}botan base64_dec testout.txt")
  end
end