class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "https://www.epicsol.org/"
  url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.6.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.6.tar.xz"
  sha256 "5b26f59321198bfa888ab2b540aec015c3a48a3530341c5116b59fb4daebf056"
  license "BSD-3-Clause"
  head "https://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d8943e1996351766d41ed63e3a948dd69880c84c248c9f1206f172fbb8e08ed4"
    sha256 arm64_ventura:  "e7b91e41258d4f61eef7e7742612e971b8e6395bfdbeb54257ee184dffb3af43"
    sha256 arm64_monterey: "483edcf940eea7329fa04a939cf0bd3d0d3155532f161e1b573eac1642cc7fbb"
    sha256 sonoma:         "c011c3d549ea2ac58be55bb9c102e75aecc9ced794912cecd8c529afe5de0c40"
    sha256 ventura:        "f92e47cdbd02478ee70b59ee0a861895c70f708cdfdc07aae6418d9dda239203"
    sha256 monterey:       "ad1e12fa44beac2b77f8cf43c414afbb80d710cb135f562394430e5de5a83376"
    sha256 x86_64_linux:   "1a22b856ba676864da57ac7b001703a4d5ef786f331c7b7bc04105e87aa11c00"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end