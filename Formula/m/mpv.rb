class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https:mpv.io"
  url "https:github.commpv-playermpvarchiverefstagsv0.38.0.tar.gz"
  sha256 "86d9ef40b6058732f67b46d0bbda24a074fae860b3eaae05bab3145041303066"
  license :cannot_represent
  revision 2
  head "https:github.commpv-playermpv.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "ce971ccc83b4bdfd0d105e693b9b039be775fbfe29868e6b67c9f98010ecb718"
    sha256 arm64_ventura:  "dec75b6b3ec01b24685d1db985ea945ffc586b99b67b56e7ee8de23d27b5e01b"
    sha256 arm64_monterey: "ab1e0c314ed9e88066ba548060229146c3761f86ff6c8519d5fdfa9e6bb34c7c"
    sha256 sonoma:         "4e9c392f96563a2b779e7c9c60bddfa463b2b91e3fd0406bd6e8ace9e356bf04"
    sha256 ventura:        "9232d665c69b49aff0cab02cd87575bdf09baafa42f7cf6c864d09873a505ee1"
    sha256 monterey:       "de9ecd10b58e04546f3196eb8699ea8da4ea6d627311971bdee0462a3624b887"
    sha256 x86_64_linux:   "3d95bb5352432924134fbc616c214ab4839d9fb59a831e5a3fb57e7000f4d2b2"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxkbcommon"
    depends_on "libxpresent"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxv"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "wayland"
  end

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default cposix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # force meson find ninja from homebrew
    ENV["NINJA"] = which("ninja")

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib"pkgconfig" if OS.mac?

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
      inreplace lib"pkgconfigmpv.pc" do |s|
        s.gsub!(^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$,
                "Requires.private:\\1#{libarchive}libpkgconfiglibarchive.pc\\3")
      end
    end

    bash_completion.install "etcmpv.bash-completion" => "mpv"
    zsh_completion.install "etc_mpv.zsh" => "_mpv"
  end

  test do
    system bin"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin"mpv --vf=help")

    # Make sure `pkg-config` can parse `mpv.pc` after the `inreplace`.
    system "pkg-config", "mpv"
  end
end