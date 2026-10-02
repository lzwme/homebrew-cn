class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://ghfast.top/https://github.com/libimobiledevice/libimobiledevice/releases/download/1.4.0/libimobiledevice-1.4.0.tar.bz2"
  sha256 "23cc0077e221c7d991bd0eb02150a0d49199bcca1ddf059edccee9ffd914939d"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a03c9a613bd9b5e84ab9259eeeecd8b62f147441d467b75beb7e19bb7f3ea887"
    sha256 cellar: :any, arm64_tahoe:       "ac7bc52f4a95b6bd20cc15232d21b3ed7c0a5c40c89156895de10ce1a301d59c"
    sha256 cellar: :any, arm64_sequoia:     "d1a3daa1a9ad566a86f553d4d3c677f9870c7f4e489155b581d6e6bc96d14cf4"
    sha256 cellar: :any, arm64_linux:       "a7e06622c240701fc5723138da9c6cec6d2fa16dc3a3085deb835fca7b7b63be"
    sha256 cellar: :any, x86_64_linux:      "75cd18a11ff1b43ef5eb2309b2da670914dc58b8e9e27e52856262f5859ed1a2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice-glue"
  depends_on "libplist"
  depends_on "libtasn1"
  depends_on "libtatsu"
  depends_on "libusbmuxd"
  depends_on "openssl@3"

  on_linux do
    depends_on "readline"
  end

  deny_network_access!

  def install
    # As long as libplist builds without Cython bindings,
    # so should libimobiledevice as well.
    args = %w[
      --disable-silent-rules
      --without-cython
      --enable-debug
    ]

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"idevicedate", "--help"
  end
end