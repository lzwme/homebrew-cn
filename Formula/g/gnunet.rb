class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.26.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.26.0.tar.gz"
  sha256 "98291afa42b91aca053d04290807be90cbab03e98682e720815803dd94e60bc3"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ad8226b168f35b8b19f5b72dcb350a8db6e17ad5654a3ed2ec38e4222b56cfa1"
    sha256 cellar: :any, arm64_sequoia: "8f3219d21d9830dcf012eb7bea95b729a7a5b17630bc7dcacb629920ff1d0e60"
    sha256 cellar: :any, arm64_sonoma:  "bf9ae8e935eeab2edd9a84219aa76ad636b83c7ac1f3fca1d820423ed33c55d7"
    sha256 cellar: :any, sonoma:        "daef44dd610b90b6d4a03de465a1f5527c2e4e64a19b4702bd3e3cbffebb6bb0"
    sha256               arm64_linux:   "759c847cd5728f526818ceab32ba8ccc15173aacad8677f9df0848a16d4799e2"
    sha256               x86_64_linux:  "f98fa0cd24d7a5f6df19e922cd29886962aa699b294f98a7a0670403b4336fdd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libtool"
  depends_on "libunistring"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    # Workaround for htobe64 added to macOS 26 SDK until upstream updates
    # https://git.gnunet.org/gnunet.git/plain/src/include/gnunet_common.h
    ENV.append_to_cflags "-include sys/endian.h" if OS.mac? && MacOS.version >= :tahoe

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"gnunet.conf").write <<~EOS
      [arm]
      START_DAEMON = YES
      START_SERVICES = "dns,hostlist,ats"
    EOS

    system bin/"gnunet-arm", "-c", "gnunet.conf", "-s"
  end
end