class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.2.tar.gz"
  sha256 "e8e073c271250adf4f665d1c9a98eee1ae589e8e3bbedb2c106a3bd94dee96cc"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "aa5dde3a022e5d4fe65685d22b5e0fc5538b90cb131155681b5c613b1c4150b1"
    sha256 arm64_ventura:  "956c22aad8135b0050ce1d50439fde127dc223587c838d8fcbf7ad93b4e2888d"
    sha256 arm64_monterey: "1b7f99974f9c6aebd52a71dc87c564cb65283bb9c626aad145f461b548b63d64"
    sha256 sonoma:         "64474170ed80e48a4b794368a9363699b10e2235d62cc4f231c86bbc9d21bf32"
    sha256 ventura:        "83709a04905c6b679f1d30ad280065ef91d86b2cb825670d3e1018305f2bcfb6"
    sha256 monterey:       "95f132d3e69aaef732e0081f9bcc2fc79b34b79155071ca6bee5bfb8a7026b03"
    sha256 x86_64_linux:   "ef78cb40b1a1706d836fffefd97bec7b144ca47b6fedc38104eda242d7a38c06"
  end

  depends_on "pkg-config" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--with-rsync=#{Formula["rsync"].opt_bin}/rsync",
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  def post_install
    # make the var/db,cache/rpki-client dirs
    (var/"db/rpki-client").mkpath
    (var/"cache/rpki-client").mkpath
  end

  test do
    assert_match "VRP Entries: 0 (0 unique)", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1")
    assert_match "rpki-client-portable #{version}", shell_output("#{sbin}/rpki-client -V 2>&1")
  end
end