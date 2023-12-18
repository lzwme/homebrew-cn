class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https:github.comchaospowerman"
  license "GPL-2.0-or-later"

  stable do
    url "https:github.comchaospowermanreleasesdownloadv2.3.27powerman-2.3.27.tar.gz"
    sha256 "1575f0c2cc49ba14482582b9bbba19e95496434f95d52de6ad2412e66200d2d8"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "fd35a442ecd342e00a4c09e0c29f49eefea4b07e08756742ab5af006dbc77a29"
    sha256 arm64_ventura:  "111132a22f3537ebc1726cec49965768bc874fabaf46b2c2c7e5c1dfe7bd6c1c"
    sha256 arm64_monterey: "bf7397842c0e10d990a848340dfb2287596ed94591840997a946886edfb307d9"
    sha256 arm64_big_sur:  "9742622a1433440ff96eb624c08a9b28c30fa12d4d120bc3d73072acc371a968"
    sha256 sonoma:         "6652f45479868d7d41e481ab3a37c76caa95d254a89a3697f95ee66f11fc8e47"
    sha256 ventura:        "07d0663bbe475dbe29617e4a7678ca4a6076303da2c1553a8fc2ca411ac0b575"
    sha256 monterey:       "518f201a1163ea0c947a9322360f7020f45f5d115752b06497baadbe0cc3f987"
    sha256 big_sur:        "a493a8832e7af6dce239bdea4db718455d5d919c39ff3fc027a5b7192f0416f4"
    sha256 catalina:       "a453e51a5217c9bb4846590f195710c693aa38382ea78b14750437a3fba53784"
    sha256 x86_64_linux:   "15e926da608bdb3d7aa8ddd394f85608cd7effaa775df653059a5ed6c4809f32"
  end

  head do
    url "https:github.comchaospowerman.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "curl"

  def install
    system ".autogen.sh" if build.head?
    system ".configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-httppower",
                          "--with-ncurses",
                          "--without-genders",
                          "--without-snmppower",
                          "--without-tcp-wrappers"
    system "make", "install"
  end

  test do
    system "#{sbin}powermand", "-h"
  end
end