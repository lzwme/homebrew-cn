class Libf2c < Formula
  desc "Support librariy for f2c translated applications"
  homepage "http://www.netlib.org/f2c/"
  url "http://deb.debian.org/debian/pool/main/libf/libf2c2/libf2c2_20140711.orig.tar.xz"
  version "20140711"
  sha256 "348c21e93752fd93d80ac5cc75f2e34e09bd7de3ae1aa3539eb8005c5a7e61d6"

  def install
    # f2c header and libf2c.a
    system "make", "-f", "makefile.u", "f2c.h"
    include.install "f2c.h"

    system "make", "-f", "makefile.u"
    lib.install "libf2c.a"
  end
end