class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v6/squid-6.5.tar.xz"
  sha256 "5070f8a3ae6666870c8fc716326befb0a1abe8b5ff3a6f3932cbc5543d7c8549"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/"
    regex(%r{<td>\s*v?(\d+(?:\.\d+)+)\s*</td>}im)
  end

  bottle do
    sha256 arm64_sonoma:   "4ea12e2e42d1c9e17b2f6c4e3c2d897030b3f8a117e7a2ab927668873e381397"
    sha256 arm64_ventura:  "91437b9cb20ec5da59b2592202f437eb84d291475f9bbc496f05083917d27478"
    sha256 arm64_monterey: "af447106753a976d53895154926a3c3b2b3d24bef32ccac06b58d51d3d05f753"
    sha256 sonoma:         "f1c9cf7bb847e779e60a93f3b393b35a542751ec093e3769dd60700b0f4e3430"
    sha256 ventura:        "727d33520dc7d5a7841c6c83c37318ce03a40b57510f01429a89e690402f328f"
    sha256 monterey:       "8c2ba6e6298f1a463e55ed001c948471810872097d503333de044929d4bd1d1c"
    sha256 x86_64_linux:   "efd191966dc27a2bdc3705594d7132c49157b6bf3130c7e2338d296cffdd44d4"
  end

  head do
    url "git://git.launchpad.net/squid", branch: "v6"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  def install
    # https://stackoverflow.com/questions/20910109/building-squid-cache-on-os-x-mavericks
    ENV.append "LDFLAGS", "-lresolv"

    # For --disable-eui, see:
    # http://www.squid-cache.org/mail-archive/squid-users/201304/0040.html
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --enable-ssl
      --enable-ssl-crtd
      --disable-eui
      --enable-pf-transparent
      --with-included-ltdl
      --with-gnutls=no
      --with-nettle=no
      --with-openssl
      --enable-delay-pools
      --enable-disk-io=yes
      --enable-removal-policies=yes
      --enable-storeio=yes
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run [opt_sbin/"squid", "-N", "-d 1"]
    keep_alive true
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/squid -v")

    pid = fork do
      exec "#{sbin}/squid"
    end
    sleep 2

    begin
      system "#{sbin}/squid", "-k", "check"
    ensure
      exec "#{sbin}/squid -k interrupt"
      Process.wait(pid)
    end
  end
end