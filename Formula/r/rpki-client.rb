class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.7.tar.gz"
  sha256 "b3b004dd0e2665e98b0e16435bf85ff0e7749db673f382005f938fa86143b37e"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "34e1a8674a0cd87085fc2445f29dd47b6cb76999ab4d714b1184ab8000ec3e3a"
    sha256 arm64_ventura:  "9585f575c2868948368f412b6c20b7b1442944dd5a120573ff2607a7c0bd21b1"
    sha256 arm64_monterey: "39be9e4494ef3685a9a159df1cb0cf6b473c188f014ec6b51d3b3cd0b9238728"
    sha256 sonoma:         "3e2715e696f9536c670c09c4e60377c9d6c0f6795ea2297ae33ceecd5fd99419"
    sha256 ventura:        "9ddbd2c8f6157571cb9479cefdbc1b3e3b6270d915ca05f28eb5e01fcdafca0d"
    sha256 monterey:       "4fb066ca110065de2f0c686f720ad816120826c6fa09b2b6d8372449dff20695"
    sha256 x86_64_linux:   "9a6909e8b4bfa7c7a3ec2d2d2814dabcc0cc7a29c31bf2d8cd2bdb127aa35a46"
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