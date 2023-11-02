class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://pan.rebelbase.com"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.155/pan-v0.155.tar.bz2"
  sha256 "3624ac3171fa8089825ce55b62b053db4f86d592f717c4d874c48ce0e885dff2"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "9995d00e0ba6d07fe9fe3a271c3133ff31e5da106383d96593714bc8ed4bcf3a"
    sha256 arm64_ventura:  "873724a984f6e7839fd5a9947f423280977165da3db7868ba5e9db9d534b8083"
    sha256 arm64_monterey: "89c7f22316455b0b6e346b76974c366342266ee19a639db37602326e9d1717a6"
    sha256 sonoma:         "9b6723e941f00aa205a929ac82645111649071abd7339b56a3a08edaa8b7cfbc"
    sha256 ventura:        "b2dbaa803a0babc78e70a72a659686fa55a7492d253c966e6b649082a2020a76"
    sha256 monterey:       "9b3ae4ff209499cf00ae7802bf2ac3836d358d32d3ab2d8135732e6d6f284249"
    sha256 x86_64_linux:   "d07382a16da0bd0b1324f7397979179aaad46861880a6d5dade15f1cf7727149"
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