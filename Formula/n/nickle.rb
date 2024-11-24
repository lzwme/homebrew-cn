class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.101.tar.xz"
  sha256 "e6faaef0bfd6e4d2362e361e652809789de248ffe5ea26c0df135f35b79a132d"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "086d96c6d7654c8dff548cea841b36708e5ec48652691360a822c45586b7191f"
    sha256 arm64_sonoma:  "b92df9ca14b05dc3ab95bfe8fcdb1e490d88f2d62d4da930b13a6fbf5e36e993"
    sha256 arm64_ventura: "ac06c1f80b2239e1e83c8d30be1a90bd4190c4859dae00569e34d22e6beff1fd"
    sha256 sonoma:        "126b3d10b45bbaf8cd57064291be29870ca99faf070ef773e9210654c211d4e1"
    sha256 ventura:       "c346eb183a5491ce280c5a16fe4e1b3bce57e6650cb6aea471bc066adfedc33b"
    sha256 x86_64_linux:  "21aee2fc692a614e3e5db78e083e802b3132e36b07f2e7f0b07adef96f9c8386"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "pkgconf" => :build
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