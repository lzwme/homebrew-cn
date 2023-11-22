class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://ghproxy.com/https://github.com/mpv-player/mpv/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "1d2d4adbaf048a2fa6ee134575032c4b2dad9a7efafd5b3e69b88db935afaddf"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "138172add80e63b5347de6504ebc44b5cde9a2f29bc743dd3f034c3f7e155f6e"
    sha256 arm64_ventura:  "11172d26a25da573afcc9e6e565e36bfcd6fc5d4aefba14e5c84034a1109bebb"
    sha256 arm64_monterey: "3fd9665998790ceeaa8970d4fe1a83cad11a1205217d27268558019af253bbc2"
    sha256 sonoma:         "7bc305287aff08a70994007893838e19b7c0a900b9839e3428007e961704bba2"
    sha256 ventura:        "fa372ecbffc5f1e83c675bc88a4e937c7633ef3752178de7544c1de011dc98e1"
    sha256 monterey:       "ad52f225d8da387aa9b27be6c3c02584d90bd94410f16db711d6ae629866a69e"
    sha256 x86_64_linux:   "f7d4b7a1d9f224f134478b6d3f8865878058c4e1aae9189043252c862501af56"
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