class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.22.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.22.2.tar.gz"
  sha256 "4e78fdd08b46408ec21b6c05a00d56fd649457123dcd929887264fde51e845e3"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc769cbdc29e7e87e826b4aba00be21c12db34d456d2de84e7b46326040c7316"
    sha256 cellar: :any,                 arm64_sonoma:  "04328fd5df9ab7133f7ee0ed28edf5af6413e5085b1da6f1788f824faef47e45"
    sha256 cellar: :any,                 arm64_ventura: "c19afb381d719340936388950fc6e7c4fe52e1a65f3624ccd2eca9bb198653ec"
    sha256 cellar: :any,                 sonoma:        "ae8b36a0e8806ad373afc38850e353053da79aaafb73f45a3063743831a44f2a"
    sha256 cellar: :any,                 ventura:       "ac78575b4cd919f0583da665d3c122834496dd9eea8aaa41bb9bde02865b7e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5bae678ede4b9bc6b6d9518f455aa7191fc903c939ddd07a5bee3bd8d27586e"
  end

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
    ENV.deparallelize if OS.linux?

    system "./configure", "--disable-documentation", *std_configure_args
    system "make", "install"
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