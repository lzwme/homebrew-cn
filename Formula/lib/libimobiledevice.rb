class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://ghproxy.com/https://github.com/libimobiledevice/libimobiledevice/releases/download/1.3.0/libimobiledevice-1.3.0.tar.bz2"
  sha256 "53f2640c6365cd9f302a6248f531822dc94a6cced3f17128d4479a77bd75b0f6"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d455f6c2631261d5698d731d55794f12352a38b4eaa10f9058b1f5276332fdee"
    sha256 cellar: :any,                 arm64_ventura:  "70b129a29fcade5e0717d8f7b747158294bcc81be05163c072b1f8bb069489de"
    sha256 cellar: :any,                 arm64_monterey: "307443c3218998505bc71579e9f7ba270f17d825dc59f7cbdac51705cba14760"
    sha256 cellar: :any,                 arm64_big_sur:  "b9b7296bb7f0573e62bdd3d6f9637b6206455b7628a80db653f5636e13bbc6a3"
    sha256 cellar: :any,                 sonoma:         "fd8262cf3042ff35bfad05eee1029d985a22ede3dd16286fbf9f4728ecebc6d7"
    sha256 cellar: :any,                 ventura:        "bf17ea268adc5a0e2f0a20fe0a54cadfddd93694034571958492f33337ce201e"
    sha256 cellar: :any,                 monterey:       "fa00bbc261ab959da8712ddcdf118019321870216d6d92eb5243273598ebbe84"
    sha256 cellar: :any,                 big_sur:        "fb8e517ba7c3d558f22513d32844c6810c49c37a59241191b7ee6e2a509775f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9543f31389a43c41fafeed7e92c477aa9fb936ecd75de0397c3bf337c49ee1c9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libtasn1"
  depends_on "libusbmuxd"
  depends_on "openssl@3"

  def install
    # Make libimobiledevice work with libplist 2.3.0
    # Remove this once libimobiledevice gets a new release
    inreplace "common/utils.h", "PLIST_FORMAT_XML", "PLIST_FORMAT_XML_" if build.stable?
    inreplace "common/utils.h", "PLIST_FORMAT_BINARY", "PLIST_FORMAT_BINARY_" if build.stable?

    # As long as libplist builds without Cython bindings,
    # so should libimobiledevice as well.
    args = %w[
      --disable-silent-rules
      --without-cython
      --enable-debug
    ]

    system "./autogen.sh", *std_configure_args, *args if build.head?
    system "./configure", *std_configure_args, *args if build.stable?
    system "make", "install"
  end

  test do
    system "#{bin}/idevicedate", "--help"
  end
end