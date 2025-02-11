class Oggz < Formula
  desc "Command-line tool for manipulating Ogg files"
  homepage "https:www.xiph.orgoggz"
  url "https:downloads.xiph.orgreleasesliboggzliboggz-1.1.2.tar.gz", using: :homebrew_curl
  mirror "https:ftp.osuosl.orgpubxiphreleasesliboggzliboggz-1.1.2.tar.gz"
  sha256 "c97e4fba7954a9faf79ddcf406992c6f7bb0214e96d4957a07a2fda0265e5ab2"
  license "BSD-3-Clause"

  livecheck do
    url "https:ftp.osuosl.orgpubxiphreleasesliboggz?C=M&O=D"
    regex(href=.*?liboggz[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48a6446abfe82b2a33b36eeab710d4429be251044b491484fccd70268f11ca9b"
    sha256 cellar: :any,                 arm64_sonoma:  "b289b62ba4e66ec2bcc98ca4ac8985afc2f37f6c695f9157cfe2b1d065f751d8"
    sha256 cellar: :any,                 arm64_ventura: "b35088aa449f3e331b910f664e45f00cdf2c8db321432701e0c0fc761839baf4"
    sha256 cellar: :any,                 sonoma:        "7ab344ff3774c0a7ef10f825d8c882cc1b8f989d8fea02d0ca9a8b26f10f6dd4"
    sha256 cellar: :any,                 ventura:       "718efe8fcff7813bc7c89563e83e41fa69811449d6f5261b9de81fb41f78eefb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ff315995858ae29fc0d883c7cfdca0f33a49a800d06d88148aa415df214e6d"
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"

  # build patch to include `<inttypes.h>` to fix missing printf format macros
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesc7dd59ab42edc3652529563bfb12ca9d1140c4afliboggz1.1.2-inttypes.patch"
    sha256 "0ec758ab05982dc302592f3b328a7b7c47e60672ef7da1133bcbebc4413a20a3"
  end

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin"oggz", "known-codecs"
  end
end