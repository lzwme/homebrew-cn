class Libf2c < Formula
  desc "Support librariy for f2c translated applications"
  homepage "http://www.netlib.org/f2c/"
  url "http://deb.debian.org/debian/pool/main/libf/libf2c2/libf2c2_20240504.orig.tar.xz"
  version "20240504"
  sha256 "85989f4f1ec3db3b1581bd16a807be3bb3a1f547f7fe7ba4e074d02710521aef"

  livecheck do
    url "https://salsa.debian.org/debian/libf2c2.git"
    strategy :git do |tags|
      tags.filter_map { |tag| tag.split("/", 2)[1].split("-", 2)[0] }
    end
  end

  def install
    # f2c header and libf2c.a
    system "make", "-f", "makefile.u", "f2c.h"
    include.install "f2c.h"

    system "make", "-f", "makefile.u"
    lib.install "libf2c.a"
  end
end