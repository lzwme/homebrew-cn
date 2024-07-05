class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https:mpv.io"
  url "https:github.commpv-playermpvarchiverefstagsv0.38.0.tar.gz"
  sha256 "86d9ef40b6058732f67b46d0bbda24a074fae860b3eaae05bab3145041303066"
  license :cannot_represent
  revision 2
  head "https:github.commpv-playermpv.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "93d5aa968907b390fcd666243a1dcb6a66a059216f79d3560203ce1da3b412c1"
    sha256 arm64_ventura:  "9c95d2ac2955c3fb4a94c0424eacb328c58f45c218c55c2a12a896cda30d382b"
    sha256 arm64_monterey: "941e7df30544e5e570fdf3ff91d34ecda42604586ae0c4cebd6f8016c581bbd8"
    sha256 sonoma:         "8f37893df91d065a0a263ae10a0e5962620fdf245c8c5f4bb0d56dc22957f9a8"
    sha256 ventura:        "76e6244d443ed7ec9fd093e4862a3300433e91346b70f868311e01e722a20912"
    sha256 monterey:       "b1fbee73afe693264741b853a622b123c5bd6e836f9884d6bbfb019059a38053"
    sha256 x86_64_linux:   "e344dd51ed38cb8711a651aef37ce12d9677054cb2ad71adca20ac550f9b5b73"
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