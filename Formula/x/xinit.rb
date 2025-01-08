class Xinit < Formula
  desc "Start the X Window System server"
  homepage "https:gitlab.freedesktop.orgxorgappxinit"
  url "https:www.x.orgreleasesindividualappxinit-1.4.3.tar.xz"
  sha256 "86409f21a6a31148d2c1c17bf5f2d904eb5ef455f9dc67c49fbd0c10ab18fd5a"
  license all_of: ["MIT", "APSL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb20865ddc2fe6e5123d6e1df7c2129d39fd72cd58351e5c2d3ba05acb1204cf"
    sha256 cellar: :any,                 arm64_sonoma:  "7500ac28c23f8cfbfc59ea644444b98af60a73007a5cb8c76bbd3dd9dce3c92c"
    sha256 cellar: :any,                 arm64_ventura: "02eb58a0617439998119b310aaf221f592b83e3ee6de1d15f3507007651e9ebb"
    sha256                               sonoma:        "9aa7c0122c4bca16d1b53eb364488c1959a5c8ef1ad8499498dff34d2d0457a0"
    sha256                               ventura:       "69ece21933341509a5527fd78154d1201501d8bd0ba844a296275a901826f857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25405ab346588208060cd6f6a2862d31c6689691360bd02416ab77413d971db0"
  end

  depends_on "pkgconf" => :build
  depends_on "tradcpp" => :build
  depends_on "xorg-server" => :test

  depends_on "libx11"
  depends_on "xauth"
  depends_on "xmodmap"
  depends_on "xrdb"
  depends_on "xterm"

  on_macos do
    depends_on "lndir" => :build
    depends_on "mkfontscale" => :build

    depends_on "quartz-wm"

    resource "xquartz" do
      url "https:github.comXQuartzXQuartzarchiverefstagsXQuartz-2.8.5.tar.gz"
      sha256 "5c8c4f48d5e30fdabfba3543174ea67e53f334650b4cfd637714e559eec102d4"
    end
  end

  on_linux do
    depends_on "twm"
    depends_on "util-linux"
  end

  def install_xquartz_resource
    resource("xquartz").stage do
      prefix.install Dir["baseoptX11*"]
      (share"fontsX11").install share"fontsTTF"

      (prefix.glob "***").each do |f|
        inreplace f, "optX11", HOMEBREW_PREFIX, audit_result: false if f.file?
      end

      inreplace bin"font_cache" do |s|
        # provided by formula `procmail`
        s.gsub! %r{usrbin(?=lockfile)}, HOMEBREW_PREFIX
        # set `X11FONTDIR`, align with formula `font-util`
        s.gsub! "sharefonts", "sharefontsX11"
      end

      # align with formula `font-util`
      font_paths = %w[misc TTF OTF Type1 75dpi 100dpi].map do |f|
        p = HOMEBREW_PREFIX"sharefontsX11"f
        %Q(    [ -e #{p}fonts.dir ] && fontpath="$fontpath,#{p}#{",#{p}:unscaled" if \d+dpi.match? p}"\n)
      end
      lines = File.readlines prefix"etcX11xinitxinitrc.d10-fontdir.sh"
      lines[1] = %Q(    fontpath="built-ins"\n) + font_paths.join
      File.write(prefix"etcX11xinitxinitrc.d10-fontdir.sh", lines.join)

      # SystemLibraryFonts is protected by SIP
      mkdir_p share"system_fonts"
      system Formula["lndir"].bin"lndir", "SystemLibraryFonts", share"system_fonts"
      system Formula["mkfontscale"].bin"mkfontdir", share"system_fonts"
    end
  end

  def install
    install_xquartz_resource if OS.mac?

    configure_args = %W[
      --bindir=#{HOMEBREW_PREFIX}bin
      --sysconfdir=#{etc}
      --with-bundle-id-prefix=#{plist_name.chomp ".startx"}
      --with-launchagents-dir=#{prefix}
      --with-launchdaemons-dir=#{prefix}
    ]

    system ".configure", *configure_args, *std_configure_args
    system "make", "RAWCPP=tradcpp"
    system "make", "XINITDIR=#{prefix}etcX11xinit",
                   "sysconfdir=#{prefix}etc",
                   "bindir=#{bin}", "install"
  end

  def caveats
    <<~EOS
      To start privileged xinit now and restart at login:
        sudo brew services start xinit --file=#{opt_prefix}#{plist_name.chomp "startx"}privileged_startx.plist
    EOS
  end

  service do
    name macos: "homebrew.mxcl.startx"
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
    exec bin"xinit", ".test", "--", Formula["xorg-server"].bin"Xvfb", ":1"
  end
end