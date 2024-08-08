class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https:www.inet.nodante"
  url "https:www.inet.nodantefilesdante-1.4.3.tar.gz"
  sha256 "418a065fe1a4b8ace8fbf77c2da269a98f376e7115902e76cda7e741e4846a5d"
  license "BSD-Inferno-Nettverk"

  livecheck do
    url "https:www.inet.nodantedownload.html"
    regex(href=.*?dante[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b273465c7d070d8d338d692180991fe27908c2c959ef367dcb9eb20eb27cdfa"
    sha256 cellar: :any,                 arm64_ventura:  "a922a104d5d267fffd6cbc3a7e476ecf9ac4ffe71c6b3b90880fd3c2df661a04"
    sha256 cellar: :any,                 arm64_monterey: "6ba49e77d7e95f26793d9283ea19a0fd2649480808873491ce1263087e0bab0f"
    sha256 cellar: :any,                 arm64_big_sur:  "7b25a50f17292cdad4dd0e52de401117411fc6bb660c66bedbdbc8c7759dea9a"
    sha256 cellar: :any,                 sonoma:         "202bfc8928a1809577a5ea36cbb4d5ee3eeca3b34a99ab8e511406e9a4fe399a"
    sha256 cellar: :any,                 ventura:        "5e7f2f4d7eefed3dedc103f89cd6f0b91fb9b67e6569f90ac20df70bc4d083f3"
    sha256 cellar: :any,                 monterey:       "df57fb7fae717cc7673b29a6665d6f6f74f9d32e3ea959174e65ff31ce87db9f"
    sha256 cellar: :any,                 big_sur:        "098dc6c46d4ee77860f8fefcd44bc21533bf70423add42de899910757796d410"
    sha256 cellar: :any,                 catalina:       "4b33f0996ade01cae7bc72f40cf7c8011f86133755e782cc40a15a0d610560c1"
    sha256 cellar: :any,                 mojave:         "f6348c63fff9dbf5392ccb1b769e9643e248e00913aba9bcb24dc928f153b526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ae4553c91fc1991fd495f3b3e25d92fa7cbd59bd7d32f8fc71444f02bbbee5"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system ".configure", "--disable-debug",
                          "--disable-silent-rules",
                          # Enabling dependency tracking disables universal
                          # build, avoiding a build error on Mojave
                          "--enable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}dante"
    system "make", "install"
  end

  test do
    system "#{sbin}sockd", "-v"
  end
end