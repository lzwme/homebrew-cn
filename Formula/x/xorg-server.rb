class XorgServer < Formula
  desc "X Window System display server"
  homepage "https:www.x.org"
  url "https:www.x.orgreleasesindividualxserverxorg-server-21.1.16.tar.xz"
  sha256 "b14a116d2d805debc5b5b2aac505a279e69b217dae2fae2dfcb62400471a9970"
  license all_of: ["MIT", "APSL-2.0"]

  bottle do
    sha256 arm64_sequoia: "c8c981ad73c464046aea344aa2b3c2f1da9d369dea5d3efc7b3f1434404261e5"
    sha256 arm64_sonoma:  "c801d9b92dfa0e22215ec713a529adc21aee251f58e36209a131968b0810a2fc"
    sha256 arm64_ventura: "95d06c50ea36876e214d2da78bb45e9e46e56d98b10a44d9d3e29bc387afb1f5"
    sha256 sonoma:        "018cbca8852500f6e6ecffe0b01084c60f301c13e8e81fa274975f3025f410cc"
    sha256 ventura:       "f37023286d3363eb226fa6a5216f10aa2f63eaab56b26bdd7e5f77260d965671"
    sha256 x86_64_linux:  "e32e75a94165706b41839706f6a4473c402403a6d7d37f7b3122cf4f74262ab8"
  end

  depends_on "font-util"   => :build
  depends_on "libxkbfile"  => :build
  depends_on "meson"       => :build
  depends_on "ninja"       => :build
  depends_on "pkgconf"     => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => :build
  depends_on "xtrans"      => :build

  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxcb"
  depends_on "libxdmcp"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxfont2"
  depends_on "mesa"
  depends_on "pixman"
  depends_on "xauth"
  depends_on "xcb-util"
  depends_on "xcb-util-image"
  depends_on "xcb-util-keysyms"
  depends_on "xcb-util-renderutil"
  depends_on "xcb-util-wm"
  depends_on "xkbcomp"
  depends_on "xkeyboardconfig"

  on_macos do
    depends_on "libapplewm"
  end

  on_linux do
    depends_on "dbus"
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libpciaccess"
    depends_on "libtirpc"
    depends_on "libxcvt"
    depends_on "libxshmfence"
    depends_on "nettle"
    depends_on "systemd"

    resource "xvfb-run" do
      url "https:salsa.debian.orgxorg-teamxserverxorg-server-rawxorg-server-2_21.1.13-3debianlocalxvfb-run"
      sha256 "fd05e0f8e6207c3984b980a0f037381c9c4a6f22a6dd94fdcfa995318db2a0a4"
    end

    resource "xvfb-run.1" do
      url "https:salsa.debian.orgxorg-teamxserverxorg-server-rawxorg-server-2_21.1.13-3debianlocalxvfb-run.1"
      sha256 "08f14f55e14e52e5d98713c4d8f25ae68d67e2ee188dc0247770c6ada6e27c05"
    end
  end

  def install
    # ChangeLog contains some non relocatable strings
    rm "ChangeLog"
    meson_args = std_meson_args.map { |s| s.sub prefix, HOMEBREW_PREFIX } + %W[
      -Dxephyr=true
      -Dxf86bigfont=true
      -Dxcsecurity=true

      -Dbundle-id-prefix=#{Formula["xinit"].plist_name.chomp ".startx"}
      -Dbuilder_addr=#{tap.remote}
      -Dbuilder_string=#{tap.name}
    ]
    # macOS doesn't provide `authdes_cred` so `secure-rpc=false`
    # glamor needs GLX with `libepoxy` on macOS
    if OS.mac?
      meson_args += %w[
        -Dsecure-rpc=false
        -Dapple-applications-dir=libexec
      ]
    end

    # X11.app need startx etc. in the same directory
    destdir = buildpath"dest"
    system "meson", "setup", *meson_args, "build"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build", "--destdir", destdir
    prefix.install Dir["#{destdir}#{HOMEBREW_PREFIX}*"]
    # follow https:github.comXQuartzXQuartzblobmaincompile.sh#L955
    bin.install_symlink bin"Xquartz" => "X" if OS.mac?

    if OS.linux?
      bin.install resource("xvfb-run")
      man1.install resource("xvfb-run.1")
    end
  end

  def caveats
    <<~EOS
      To launch X server, it is recommend to install xinit,
      especially on macOS, otherwise X11.app will not work:
        brew install xinit
      If cask xquartz is installed, this link may be helpful:
        https:www.xquartz.orgFAQs.html#want-another-x11app-server
    EOS
  end

  test do
    (testpath"test.c").write <<~C
      #include <assert.h>
      #include <xcbxcb.h>

      int main(void) {
        xcb_connection_t *connection = xcb_connect(NULL, NULL);
        int has_err = xcb_connection_has_error(connection);
        assert(has_err == 0);
        xcb_disconnect(connection);
        return 0;
      }
    C
    xcb = Formula["libxcb"]
    system ENV.cc, ".test.c", "-o", "test", "-I#{xcb.include}", "-L#{xcb.lib}", "-lxcb"

    fork do
      exec bin"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    system ".test"

    system bin"xvfb-run", ".test" if OS.linux?
  end
end