class XorgServer < Formula
  desc "X Window System display server"
  homepage "https:www.x.org"
  url "https:www.x.orgreleasesindividualxserverxorg-server-21.1.11.tar.xz"
  sha256 "1d3dadbd57fb86b16a018e9f5f957aeeadf744f56c0553f55737628d06d326ef"
  license all_of: ["MIT", "APSL-2.0"]

  bottle do
    sha256 arm64_sonoma:   "d271ef9ea9ef937bad17cbe2736629ef2c611b452ae7df118ff2e11cf32268e0"
    sha256 arm64_ventura:  "5d606fde47967d49c2e9b4e78f7161d8162f5e7ac08d11870baaa9323daca7b3"
    sha256 arm64_monterey: "1bead017cb73412a5f16bf8b480dddb01ef28ea93ba0ba9c0e4cee8ac50d916a"
    sha256 sonoma:         "d028669f5c0ff0a050b8700530a998c8564933f88628435bd949bfa492ea6d88"
    sha256 ventura:        "4b89600f873e34caf34292126a34a7b7049e3d79834a5f4e4e615dfffc18431b"
    sha256 monterey:       "d063a09beb9c9109cf9066c10ca3f266f34c9aa2afef335b3c450f0497f815b1"
    sha256 x86_64_linux:   "4029a49689f4722db3044c507b4a08b17dd62049b69a2e506b3cdbfa27fabee4"
  end

  depends_on "font-util"   => :build
  depends_on "libxkbfile"  => :build
  depends_on "meson"       => :build
  depends_on "ninja"       => :build
  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => :build
  depends_on "xtrans"      => :build

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
    depends_on "libtirpc"
    depends_on "libxcvt"
    depends_on "libxshmfence"
    depends_on "nettle"
    depends_on "systemd"

    resource "xvfb-run" do
      url "https:salsa.debian.orgxorg-teamxserverxorg-server-rawxorg-server-2_21.1.4-1debianlocalxvfb-run"
      sha256 "fd05e0f8e6207c3984b980a0f037381c9c4a6f22a6dd94fdcfa995318db2a0a4"
    end

    resource "xvfb-run.1" do
      url "https:salsa.debian.orgxorg-teamxserverxorg-server-rawxorg-server-2_21.1.4-1debianlocalxvfb-run.1"
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
    (testpath"test.c").write <<~EOS
      #include <assert.h>
      #include <xcbxcb.h>

      int main(void) {
        xcb_connection_t *connection = xcb_connect(NULL, NULL);
        int has_err = xcb_connection_has_error(connection);
        assert(has_err == 0);
        xcb_disconnect(connection);
        return 0;
      }
    EOS
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