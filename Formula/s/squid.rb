class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v6/squid-6.11.tar.xz"
  sha256 "b6e60c08429314287925331b3da6c03b7d3c35b7e03319f78edb8bad6fc68899"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.squid-cache.org/Versions/"
    regex(%r{<td>\s*v?(\d+(?:\.\d+)+)\s*</td>}im)
  end

  bottle do
    sha256 arm64_sequoia: "d74b1073ecdf2c60e96a53d3eca51fdcb8d281d62a103db77e1a26938dc097ab"
    sha256 arm64_sonoma:  "317d109ff9d5b27852b252f3163d6922f982ce92ff9aa80dd057e74ff8151f59"
    sha256 arm64_ventura: "8b4c8d51bfe253a731bae8ea7be9507c230189bcf292b1755d427f7f53705ffe"
    sha256 sonoma:        "aa4a8a7cab9c68feff73b7dab496ec54b498a51c7a0564bbf0601b11ba8ef779"
    sha256 ventura:       "8431ceade3980d16058cdb2ee536e54544e572c5e4874df8d38fd78075b6d4d0"
    sha256 x86_64_linux:  "2a88bd15b8cdef350735c4f55ac2c19a5070432ad901e885fd7e046287e6b782"
  end

  head do
    url "https://git.launchpad.net/squid", using: :git, branch: "v6"

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
    # https://www.squid-cache.org/mail-archive/squid-users/201304/0040.html
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
    log_path var/"log/squid.log"
    error_log_path var/"log/squid.log"
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