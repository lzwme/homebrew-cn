class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://pan.rebelbase.com"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.154/pan-v0.154.tar.bz2"
  sha256 "440317954df7217689100df3dfb68865770f5aed1b8ed2b45432d771bb80a8c9"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "e4fcb1f5c2789fcceec936f1b5c02912ddae3f25c83352fbf07ebeb4736fc624"
    sha256 arm64_ventura:  "30f5b64944c582e5270b3c4d3410317cc531198b3fc6732278f0bcad59ba14dd"
    sha256 arm64_monterey: "c7f0b331a69759c3caaa49daeb52bbbdf08715cb8b666eaaba19f567a980e90d"
    sha256 sonoma:         "23e2a06deabd0b066ed75763aa6e5ee683d9ebd751b424ffb63cdcd63efd61c1"
    sha256 ventura:        "8dfdf0bcc1f5f1e22db31dcfdc33172b44d7fca653ed0a19eae9c36b0af7ac1d"
    sha256 monterey:       "180f252594529865e2aea62980dae9eb7dcc93b64883b3992c76e4921890ee97"
    sha256 x86_64_linux:   "7dcaa54b1e8306a5318357449e1022ef21684efddab8417490bd566c59ae60a2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "gtkspell3"
  depends_on "harfbuzz"
  depends_on "pango"

  def install
    # use brew name for gtk3 version of tool update-icon-cache
    inreplace "pan/icons/Makefile.am", "gtk-update-icon-cache", "gtk3-update-icon-cache"

    # fix libiconv linking https://gitlab.gnome.org/GNOME/pan/-/issues/171
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    ENV.append "CXXFLAGS", "-std=c++11"

    system "NOCONFIGURE=1 ./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-gnutls"
    system "make"
    system "make", "install"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    minimal = testpath/"minimal.nzb"
    minimal.write <<~EOS
      <?xml version="1.0" encoding="iso-8859-1"?>
      <!DOCTYPE nzb PUBLIC "-//newzBin//DTD NZB 0.9//EN" "http://www.newzbin.com/DTD/nzb/nzb-0.9.dtd">
      <nzb xmlns="http://www.newzbin.com/DTD/2003/nzb">
        <file poster="NeM &lt;NeM@orion.org&gt;" date="1698128304" subject="test - &quot;wizard.jpg&quot;  yEnc">
          <groups>
            <group>0.test</group>
          </groups>
          <segments>
            <segment bytes="80796" number="1">pan$d1fb3$7054e426$ef264b33$dab0ec15@orion.org</segment>
          </segments>
        </file>
      </nzb>
    EOS

    # this test works only if pan has not yet been configured with news servers
    assert_match "Please configure Pan's news servers before using it as an nzb client.",
      shell_output("#{bin}/pan --nzb #{testpath}/minimal.nzb 2>&1", 1)
  end
end