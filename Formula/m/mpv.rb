class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https:mpv.io"
  license :cannot_represent
  revision 2
  head "https:github.commpv-playermpv.git", branch: "master"

  stable do
    url "https:github.commpv-playermpvarchiverefstagsv0.37.0.tar.gz"
    sha256 "1d2d4adbaf048a2fa6ee134575032c4b2dad9a7efafd5b3e69b88db935afaddf"

    # Fix build with FFmpeg 7.0.
    # Remove when included in a release.
    # https:github.commpv-playermpvpull13659
    patch do
      url "https:github.commpv-playermpvcommit62b1bad755bb6141c5a704741bda8a4da6dfcde5.patch?full_index=1"
      sha256 "7d6119161f8d2adcc62c8841cee7ea858bf46e51e8d828248ca2133281e2df0a"
    end
    patch do
      url "https:github.commpv-playermpvcommit78447c4b91634aa91dcace1cc6a9805fb93b9252.patch?full_index=1"
      sha256 "69e4ead829e36b3a175e40ed3c58cc4291a5b6634da70d02b0a5191b9e6d03f6"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "503033133d2409d22408524c92939ff27a0119a0a8fbed7fc07526edacefb19c"
    sha256 arm64_ventura:  "e8603f24501346996474c0a3e098a46abbdc06a0b3a0ae9e63fcdadc4a9ecb22"
    sha256 arm64_monterey: "75b3a089692824260780773758e597003f6c803e632c2f1f9bf5f9588e081007"
    sha256 sonoma:         "80a7d43dade2df41a4ff05fe3e9846eadb77066fe30de4003d3ec4845e4047cc"
    sha256 ventura:        "e04e62d0a360f559eb5904f4e1ab161dcb9e6dd8609b8464240db5f7fe4b88e2"
    sha256 monterey:       "98584844157bb365f6b902d61e3bca9513ab326fb2a3fbbe8f85aab23b02ca4f"
    sha256 x86_64_linux:   "67dfb85317fa2ccd0a99ef9e064868c4392977a5759d840c078fce9298d53929"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "libplacebo"
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