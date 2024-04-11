class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https:mpv.io"
  url "https:github.commpv-playermpvarchiverefstagsv0.37.0.tar.gz"
  sha256 "1d2d4adbaf048a2fa6ee134575032c4b2dad9a7efafd5b3e69b88db935afaddf"
  license :cannot_represent
  revision 2
  head "https:github.commpv-playermpv.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "9354877f0ede33e63d1fc5e491a8ed726178608b0e94759cee59304a134e267c"
    sha256 arm64_ventura:  "0aa883b1d39107b6d703c337c09a6f03630834b970a91049dda3d6a1cfd29791"
    sha256 arm64_monterey: "75186bbd61df6c8f89c8dd22230de1b178d80a6741062ea59af6871e846e34ca"
    sha256 sonoma:         "8e24da5b7bd1597bc864e264b48c3af8b845b47ec0889a95d670a87ffd924ea2"
    sha256 ventura:        "2bb1fa0179b86184fbd60ecf2fe2d4dd31ee7e52d173160d383d59b6179970e3"
    sha256 monterey:       "6e3a932c7f5343bffc1e37625fb390e7f8b1205212f46e9d59d346704df6fefd"
    sha256 x86_64_linux:   "67f45ab74e5e69c1c4d2bd8d38223220d6e76c8fa343fbb3a4aa917a01b22d4c"
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