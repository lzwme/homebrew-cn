class Pan < Formula
  desc "Usenet newsreader that's good at both text and binaries"
  homepage "https://gitlab.gnome.org/GNOME/pan"
  url "https://gitlab.gnome.org/GNOME/pan/-/archive/v0.157/pan-v0.157.tar.bz2"
  sha256 "1ab5f59a9e1e9cb9bfe978be55fda812d5b46936c1c14d9dae30a555c665eb51"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "f0f8d01a20e693fff3e196754238a7cb488d35424b864c9668fbba1e46eaf06d"
    sha256 arm64_ventura:  "9a27968f0cf3aa20f7a22387dcc51a062f3987db002265b77731038bcb3ae4ce"
    sha256 arm64_monterey: "afeae9b7e194af60be2d2da2db359ff559e595fcbc041b9c71f0f310cd027018"
    sha256 sonoma:         "47bb4ec160c0148d0ef3750ae7a62edac08e5c3eba51fc361956435d3cb555a4"
    sha256 ventura:        "4087aef297472f7c8f42df6b7261083770d5bb08b72189b4a9cf2b385e680fbc"
    sha256 monterey:       "4b196dfa4e2e9ddc311ae0c5d6a2f3d26f3485cb33ae459b555315e899a8cd94"
    sha256 x86_64_linux:   "f6b0cc5dee1673657fdad6f75befb3fa9bd9dc6ace1dfd3e38dcb6ed47903cf0"
  end

  depends_on "cmake" => :build
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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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