class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://ghfast.top/https://github.com/mpv-player/mpv/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "ee21092a5ee427353392360929dc64645c54479aefdb5babc5cfbb5fad626209"
  license :cannot_represent
  revision 3
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "62fb8fa00d4e5acfbc2a4205e6fdab481df3948f7e98e2f153eaa01a38c20198"
    sha256               arm64_sequoia: "99fcb3a69832822620ea41296af7b2e71a8565e71286cc0825a854e2004c69b7"
    sha256               arm64_sonoma:  "070275c6f03a5f743821459e05542e5518ecb8b75f202deff1e732f11d5788a3"
    sha256 cellar: :any, sonoma:        "fef537744382c65ff62fb3d64b1d18f171d568e8b5ce00fbd1f6d9b7129c447e"
    sha256               arm64_linux:   "c3acb7d4c41c7733d672b8ab558c371a7ceb725c8d2fee5f7617df11a0557b96"
    sha256               x86_64_linux:  "a4e8f082ff1c243cf5affd384e6826ba06df3dc3b15076abe2e2cf5df5b36af2"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libplacebo"
  depends_on "little-cms2"
  depends_on "luajit"
  depends_on "mujs"
  depends_on "rubberband"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "vulkan-loader"
  depends_on "yt-dlp"
  depends_on "zimg"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "libxpresent"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxv"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "wayland"
    depends_on "wayland-protocols" => :no_linkage # needed by mpv.pc
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "stolendata-mpv", because: "both install `mpv` binaries"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # force meson find ninja from homebrew
    ENV["NINJA"] = which("ninja")

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig" if OS.mac?

    args = %W[
      -Dbuild-date=false
      -Dhtml-build=enabled
      -Djavascript=enabled
      -Dlibmpv=true
      -Dlua=luajit
      -Dlibarchive=enabled
      -Duchardet=enabled
      -Dvulkan=enabled
      --sysconfdir=#{pkgetc}
      --datadir=#{pkgshare}
      --mandir=#{man}
    ]
    if OS.linux?
      args += %w[
        -Degl=enabled
        -Dwayland=enabled
        -Dx11=enabled
      ]
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    if OS.mac?
      # `pkg-config --libs mpv` includes libarchive, but that package is
      # keg-only so it needs to look for the pkgconfig file in libarchive's opt
      # path.
      libarchive = Formula["libarchive"].opt_prefix
      inreplace lib/"pkgconfig/mpv.pc" do |s|
        s.gsub!(/^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$/,
                "Requires.private:\\1#{libarchive}/lib/pkgconfig/libarchive.pc\\3")
      end
    end

    bash_completion.install "etc/mpv.bash-completion" => "mpv"
    zsh_completion.install "etc/_mpv.zsh" => "_mpv"
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output("#{bin}/mpv --vf=help")

    # Make sure `pkgconf` can parse `mpv.pc` after the `inreplace`.
    system "pkgconf", "--print-errors", "mpv"
  end
end