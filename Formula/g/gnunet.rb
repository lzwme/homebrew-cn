class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.26.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.26.2.tar.gz"
  sha256 "77b7e370cd84037f5792d812536bc5a1035409e6a34aa068d08c9e81be809389"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "0099b68cd02f69fa642e104d27056897daa0d38a58c1f30b8036b18068388c65"
    sha256 cellar: :any, arm64_sequoia: "e6ba5830a7e9131c0bdb8c8678aa1271b3bed1a95dfed4ac4c9e2fb8c865c24b"
    sha256 cellar: :any, arm64_sonoma:  "b76c47e1652724f8f8dc4b5db8dbbd112249e31e6be9fc5dde9b47ae29a84196"
    sha256 cellar: :any, sonoma:        "1d8203547ab28301c849c6538ed54b84903b0fc49073a59e13fc487d6727641c"
    sha256               arm64_linux:   "c1d5ea4893427f4f7e76fdb70f53e948af231fc1c3289e68a71e716c1fc9976b"
    sha256               x86_64_linux:  "39d321f4c6a0b161dda0108d6f8f54f51ac246f130124894c4575ba9987ebadb"
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

  on_macos do
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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