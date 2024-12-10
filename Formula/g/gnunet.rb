class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.23.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.23.0.tar.gz"
  sha256 "a4c6b6d4146a6a3415bc351c185a5795c7f4addb6ce99751c4715c1790d5f67a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "696e02bb781cea314d27720b36c2ea1052434c086c1d8a20c1c1567769de314a"
    sha256 cellar: :any,                 arm64_sonoma:  "c8e177059dd78da21fbbd9c0547a0bb99945e4f09b4a2598aaef529c668af7e0"
    sha256 cellar: :any,                 arm64_ventura: "260739ee5c4dec2106bbd490357fe1245a56e0a6f08690835c8e5f153efa17b5"
    sha256 cellar: :any,                 sonoma:        "9d70cc8d468696e4638e5db590285efeeafc700b99c22ded136adec098587c79"
    sha256 cellar: :any,                 ventura:       "473384cf99500c745f2444c10d08fa3bb9b7a75a588d5e57c1c347dc0a517180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f16d1f95936842929899e59fc29ebcec6f77c85ff383f60efe9a35e42d5a595"
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