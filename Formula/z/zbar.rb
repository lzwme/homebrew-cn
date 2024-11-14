class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https:github.commchehabzbar"
  url "https:linuxtv.orgdownloadszbarzbar-0.23.93.tar.bz2"
  sha256 "83be8f85fc7c288fd91f98d52fc55db7eedbddcf10a83d9221d7034636683fa0"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "346cb49e583f75edf2e0a63cfe5f5bcba9b32f3ff9c8e8b2c56e647f6330fd12"
    sha256 arm64_sonoma:  "8f8fa3d059605a7f72a5a102898aa3ea5b0888d01b7958c4f488b8bedb1a3be0"
    sha256 arm64_ventura: "cc5de3f507ed2dad015258fb10e3e66bdbcfae0aa2699c82e16fc24b847717bc"
    sha256 sonoma:        "91c0d003d45259393ddc8a7bd9eaa0c18fcedd2f1bead963353e3aa03f241cd4"
    sha256 ventura:       "82271152893399cf0be78e7575f71344cc0eaa2f7fc7cd24c8e63abecd68d6a3"
    sha256 x86_64_linux:  "2b2a0531ffd3f8dc84916c7f182a449570feb695e399c2a2a1cc87227cebe4fd"
  end

  head do
    url "https:github.commchehabzbar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build

  depends_on "imagemagick"
  depends_on "jpeg-turbo"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "glib"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "dbus"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system ".configure", "--disable-silent-rules",
                          "--disable-video",
                          "--without-python",
                          "--without-qt",
                          "--without-gtk",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin"zbarimg", "-h"
  end
end