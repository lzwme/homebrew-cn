class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "https://www.epicsol.org/"
  url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-3.0.1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-3.0.1.tar.xz"
  sha256 "17b967c61e58874f0775e1fd0b0607f85c64b63258c1ac4d4089e811352a3945"
  license "BSD-3-Clause"
  head "https://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d77a2b3b8a145c9ab3b92caddd7aae8aac220ca45a06a46447776c8deee92ccc"
    sha256 arm64_sonoma:  "d332bdeea8d3d613f645c4dc5ad201e813d5309d1fcee0f2851ca082b8cb14da"
    sha256 arm64_ventura: "a97c8e6ea962a9b844941d646544831c6d452078a9c966f309ae7f8ace765ecc"
    sha256 sonoma:        "bcab6dac9ed21958775041e4433c9e9503f990367f048635c2c9d7b89268d798"
    sha256 ventura:       "d82f6d867cb849586d0930ef8b94a11295c5ef3715505ab14a126c677b8b784c"
    sha256 x86_64_linux:  "96d6834f5c2c4dd457ceff56a2ab29a5c8cb3bdcb63beed452fc80a2eb82ff82"
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