class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://ghproxy.com/https://github.com/mpv-player/mpv/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "41df981b7b84e33a2ef4478aaf81d6f4f5c8b9cd2c0d337ac142fc20b387d1a9"
  license :cannot_represent
  revision 1
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "231980d52bb3d8dc1e496dc00cb4a601d48219db303fb8f75a5f95b68a246b36"
    sha256 arm64_monterey: "e71fd837920adb77b0bc55016dfa1d0a76f71bcba43797a45f1c30c33b31c3ec"
    sha256 arm64_big_sur:  "12147706325bb13ce4939f3ba7d02edc232a552feb529fa9169ede577fe74faf"
    sha256 ventura:        "ae4d24028370346e03b423b5081ce826a1c01b2c17c838e53ce0ddfabd72351f"
    sha256 monterey:       "1b79eae6454c427bc3d0b95fe512ff727009dc47e9f2ff1029bd6139e68743f4"
    sha256 big_sur:        "5e5cc7e84d6c1e20a5107ca77e8d14729f299eb941a0b69cf48f5f912f3be8ac"
    sha256 x86_64_linux:   "516b4e12e778b8e157b03821ab308e41a9881d58cd5a156181f4f5eb7d5d54c3"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "luajit"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # force meson find ninja from homebrew
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"

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
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")

    # Make sure `pkg-config` can parse `mpv.pc` after the `inreplace`.
    system "pkg-config", "mpv"
  end
end