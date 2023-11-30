class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.19.1.tar.gz"
  sha256 "4fcc2b0b39a6d40e4dc3e49fac2f1cf063575d6570e93408fa4a76ab67531ae1"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b11b19323b6b778e3f08e841e78a5cabb486d1b9b24ee81ae0771fe8cff20940"
    sha256 arm64_ventura:  "7170f114604bbb698977330ecb43c2ef6e587e6828cb355f08a577e2c8eed389"
    sha256 arm64_monterey: "2e8b18790c701ddddb9b1ad1b854825870a05bb375e48cfb7d980b47ea71902e"
    sha256 sonoma:         "c194f0d08f835deb72d56ffc4365348560ba4678a5f811ca42989fb869128dd1"
    sha256 ventura:        "0bcd952f7a9f967673ced728a77e173bc350eefeb307c4a5890b4d51d8a565cf"
    sha256 monterey:       "edc2e96c4e15a6f6b64046fcdb8e74df6df50bdf85c39f02cc58144ee6f571b7"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libetpan"
  depends_on "nettle"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "LDFLAGS=-Wl,-framework -Wl,Security",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin"
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end