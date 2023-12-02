class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.94.tar.xz"
  sha256 "1d09e4c3f9ec0b71b7905303028a82cac1b223bedb9a3810d6f7184210370727"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "fd733f58ca03a64e4ae29f640d0372791b2db931d30b0ca21fd2229832f80cbb"
    sha256 arm64_ventura:  "b5199b67e640a217c89c8133c4e6400daa3f99be89334328f6b18611cdfda43b"
    sha256 arm64_monterey: "37123eca5bb70c6ac2d0f7c3bb457cc6910bba690719e765392ea96cfac23b56"
    sha256 sonoma:         "6e622cdf5f98c4487de44f590e28962842d7691eaf59c3ce5452e2b3a55ec0d2"
    sha256 ventura:        "6cf9cf73dffab15ef071cdf588f5283347aad5292cd24edc64cf4367dd541b32"
    sha256 monterey:       "3743ea9e8c74a1acd5e38e5fb0c40c1e133fdcbbad521899cb5d1b03b9f367dd"
    sha256 x86_64_linux:   "a9220899d32e294efe5ccf2ac1ef4b7e01725431be0a4af87bc8df5777f83ab3"
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