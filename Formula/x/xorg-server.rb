class XorgServer < Formula
  desc "X Window System display server"
  homepage "https:www.x.org"
  url "https:www.x.orgreleasesindividualxserverxorg-server-21.1.12.tar.xz"
  sha256 "1e016e2be1b5ccdd65eac3ea08e54bd13ce8f4f6c3fb32ad6fdac4e71729a90f"
  license all_of: ["MIT", "APSL-2.0"]

  bottle do
    sha256 arm64_sonoma:   "9f15252e57d11d443471f5275b75c657db28a60f14144e411dd442bb5554b477"
    sha256 arm64_ventura:  "82dcd5e01a964048ea2b01bf2cb311c26b0f0c658aa2d7dfce2acaa3a859dc36"
    sha256 arm64_monterey: "56fb9d4af776cc4fd675bf63c31500d1a9339e9b1c35d8870294ac87eaa00e43"
    sha256 sonoma:         "1b95fbc45ebece0b53a888f814345b43db63413cf4e8c416b58386848866f6c7"
    sha256 ventura:        "44ae05005a85e1f28b9fadce865e53c6d69eb160a5fb6ae60b091e4d1c54fe36"
    sha256 monterey:       "b04980de7faf096eff79cf3c7b78066a8c2446ca762156c8ec84a6b77b9e98e8"
    sha256 x86_64_linux:   "28e682ff36f565afbb5a8ff8e5900e21a6e1165b231fa33791722b32d15a2405"
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