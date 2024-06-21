class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https:mpv.io"
  url "https:github.commpv-playermpvarchiverefstagsv0.38.0.tar.gz"
  sha256 "86d9ef40b6058732f67b46d0bbda24a074fae860b3eaae05bab3145041303066"
  license :cannot_represent
  revision 1
  head "https:github.commpv-playermpv.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "3460326c8f7068cb517b2f16b38e391178e1f3f7b1d4eead3b1ae0c536d3bd6c"
    sha256 arm64_ventura:  "6f90b90160f4c627091c42fc7128710b34a94baba52dd5583e1aebb7648ff6e2"
    sha256 arm64_monterey: "5f2cd93af03781d7e9c3bdab2e25006854d17b8aa4b1085255ab9ea906cafb6f"
    sha256 sonoma:         "226577c75087e7b7aeda0768a2886750880c2c8c5a7be739dabeec27eb9b5e9f"
    sha256 ventura:        "1c8cbb069aecfc9423a69a2346b8be6a6215c571f64d06bcd1b95c484da59022"
    sha256 monterey:       "ac314c5391c4c44bfa544e63af1ec66adecff3567f6ba1a0ff90bd478cd6b8ef"
    sha256 x86_64_linux:   "4827ed046a9cc6edfd90415b7b68de9afb1130b93d8b7434218426d0fa0fe2fa"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libplacebo"
  depends_on "libsamplerate"
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
    depends_on "pulseaudio"
  end

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default cposix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # force meson find ninja from homebrew
    ENV["NINJA"] = Formula["ninja"].opt_bin"ninja"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib"pkgconfig"

    args = %W[
      -Dhtml-build=enabled
      -Djavascript=enabled
      -Dlibmpv=true
      -Dlua=luajit
      -Dlibarchive=enabled
      -Duchardet=enabled
      --sysconfdir=#{pkgetc}
      --datadir=#{pkgshare}
      --mandir=#{man}
    ]

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