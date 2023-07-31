class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.5.tar.gz"
  sha256 "ab04ad76d5302fccce93b167324b5f08c2384c980f9a046bba934e8358d62c0b"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "30bd0c44b7391facbc3bda4210829fdfa8ac0fdc85350336043edb67e1df78f5"
    sha256 arm64_monterey: "da77d3509798769b31f1d41418627550f5899510150d1782b4522cc2d54ee210"
    sha256 arm64_big_sur:  "f7f6e07d6683f93f54891fa66966ae17e39cda337698f4146920fd728154ca75"
    sha256 ventura:        "b219fcb162556a70a265b9bff03d923845e0f7f7fd197935fe53cc9527106b62"
    sha256 monterey:       "65614dad0b1c2f57c8bce906133ec938c67088079832d4ab26f25dc362cbc5fb"
    sha256 big_sur:        "11c19bf952dbcf0a6e2ae9de8b3b4575ebc29c14a4193a2f63857806cac5e611"
    sha256 x86_64_linux:   "58af801c06834f80c871b31d7dfea3e1416b1e2be335cfd2e19eb3fb6d9febc5"
  end

  depends_on "pkg-config" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"

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