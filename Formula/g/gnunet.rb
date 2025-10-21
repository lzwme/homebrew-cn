class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.25.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.25.2.tar.gz"
  sha256 "eab76fc35d393ab15fadb6344f843525c165619400735aa6dde0966f6a26c2e6"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8fc9e4c34bd443a153b706274d033292a6df95e86b3b1cd11e7d0be8cc315b5f"
    sha256 cellar: :any, arm64_sequoia: "4122083fd1f4f5b316278a3d25f66759cf91ebcabbb872d3096d0c6ec962dbe7"
    sha256 cellar: :any, arm64_sonoma:  "efde1ca4e65fa11c62341db26946f3e78b888be097af71640b59742dcbbfe529"
    sha256 cellar: :any, sonoma:        "745455d3ade75e8fa5be19a2c3e2cfb18f2f9e4a3c8687e15e5acff22ec2dda6"
    sha256               arm64_linux:   "9051b628927848fe09a1b62f2a131de4decacbee493d1aa8b4b588c6d9cdf902"
    sha256               x86_64_linux:  "f1e29576a69945a955b7a88e431597f3c9c7925c302a56860e0025901e071905"
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