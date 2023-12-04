class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.96.tar.xz"
  sha256 "0a6f9852b44a58afc7b053b2d766e210f1efb3980d345f4bc9ee907594ec05a4"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5b9cbbbdfa457364a0d9e64b3f8a9998129f6f440c89b6e695bfbcf54d0f02fb"
    sha256 arm64_ventura:  "ef242ffdba1d44360233ca3c774a9577ddfc2414e9936b0c5854b6b0ac101eaa"
    sha256 arm64_monterey: "453bda581d5b99eb10747504c16202c1d9e8c0f7b761912c1bd08483a691c5a2"
    sha256 sonoma:         "c5da8138c5c5acb09f08a06896854d8a8df2b42901dc449a59d3f3ec2d6cccaa"
    sha256 ventura:        "1a9557b0a4b626b93b06207ed9d8058d3eb1f7c24b5e1f0b003d0e547af2381e"
    sha256 monterey:       "57dabdfe873251beb2bf59243b061c1977ab1705acc7e62f0b059e43cdc41a1c"
    sha256 x86_64_linux:   "d0f3873fa8357b0b57ca8f4252c10d856f62e6a2e6462507fa59c4f319ae5233"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    ENV["CC_FOR_BUILD"] = ENV.cc
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end