class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "https://www.squid-cache.org/"
  url "https://ghfast.top/https://github.com/squid-cache/squid/releases/download/SQUID_7_2/squid-7.2.tar.bz2"
  sha256 "2bbbc7b55912a81dc493122c74a5b1c5a33b20239b3e33d476dddf07874fbb81"
  license "GPL-2.0-or-later"

  # The Git repository contains tags for a higher major version that isn't the
  # current release series yet, so we check the latest GitHub release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "3c24a5f1cb2a991860831a3dac5bcf94b7921231d593953f0072fcb4d60b35a8"
    sha256 arm64_sequoia: "25eb944f397881be303d454d4177a167f369b2232a93ee327545bb7e97e96c69"
    sha256 arm64_sonoma:  "f65d585f6909c5e49aa7984b5d2dea4ba225b31c3923f2d9ff2dc03cf13bfcca"
    sha256 sonoma:        "171aeec1c40349702836054f49a787dbebaa0b57fcfc88c1047768bb574e9ab3"
    sha256 arm64_linux:   "837d738110e896b847a166337cdc0aef183e790abb779984dddd39c43f100d0a"
    sha256 x86_64_linux:  "f3bb698cb95dcdb2e78712cfc4652a3ef11df72aae17dea08789d1b741aecd04"
  end

  head do
    url "https://github.com/squid-cache/squid.git", branch: "v6"

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
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --enable-ssl
      --enable-ssl-crtd
      --disable-eui
      --with-included-ltdl
      --with-gnutls=no
      --with-nettle=no
      --with-openssl
      --enable-delay-pools
      --enable-disk-io=yes
      --enable-removal-policies=yes
      --enable-storeio=yes
    ]

    args << "--enable-pf-transparent" if OS.mac?

    system "./bootstrap.sh" if build.head?
    system "./configure", *args, *std_configure_args
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