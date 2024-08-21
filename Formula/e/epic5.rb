class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "https://www.epicsol.org/"
  url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.2.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.2.tar.xz"
  sha256 "94bd21f93560013b32fe499afbfca0dd2eaec1f3b63f32fc979be4fe5a6b1670"
  license "BSD-3-Clause"
  head "https://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "39e2c865107b65a7fc09c0806c18300b802835723d47c4f015c604924cc866e3"
    sha256 arm64_ventura:  "d9904b7ad5563c69d551d6b4f38f5e4125a33d7fb446f58fff38db769d2d25bd"
    sha256 arm64_monterey: "ea670d3bd246c1f03340d88d28445220ae0f01f3a9b1652767823e185b6903ad"
    sha256 sonoma:         "41c37d3e27ee52ee67b3648e401b42a9d233e90a914caa1507f6bd615a69c6a9"
    sha256 ventura:        "e41c2da7ff16c86032479cfe41cff01b942fe63e9d44e97cc102e81a2c7f9530"
    sha256 monterey:       "ff5c82c4699af0ad3a2a5e2da1a619e30962564c8c6820971d98c1f7c225b804"
    sha256 x86_64_linux:   "200b5eafaf44c843ea6098623d83fdef580045e14cf59a99c4adeed2ec1c3e6c"
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