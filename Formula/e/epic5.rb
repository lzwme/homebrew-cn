class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "https://www.epicsol.org/"
  url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.4.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.4.tar.xz"
  sha256 "7dc3dd44f8b00d7cd486d8b738b66bcb09ead188d9fec7824c7076381aed0427"
  license "BSD-3-Clause"
  head "https://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b4320035ad7013692993f7685e56f0fd24d1d855d82308289327e972a0510f01"
    sha256 arm64_ventura:  "ef7265c72b9c687ac08531eea3329b50a0c9d0f61ce602b71bdf79d8d18d0793"
    sha256 arm64_monterey: "ddac37cc9220cb81e0f4e57b5dc7a8c3ffaeaa0b694f760582fb14881cf10e4d"
    sha256 sonoma:         "5485d28eedd36ecc695aba3591970b227ac3ad5edb652e97ba6e77dbe1325b69"
    sha256 ventura:        "bcc10bdc81dcc4bd60076ed808ce21457d51da153de4c3f09099b2be49e97ac4"
    sha256 monterey:       "637c6a05b5258b2a4536631d84e4e65642f6361915f34936770ee73d3927f7ad"
    sha256 x86_64_linux:   "710967ddca310579e0a6a583f73afed77a4ec46441bbacfb37235790d758a382"
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