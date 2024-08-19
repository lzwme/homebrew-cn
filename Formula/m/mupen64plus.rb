class Mupen64plus < Formula
  desc "Cross-platform plugin-based N64 emulator"
  homepage "https:www.mupen64plus.org"
  url "https:github.commupen64plusmupen64plus-corereleasesdownload2.5mupen64plus-bundle-src-2.5.tar.gz"
  sha256 "9c75b9d826f2d24666175f723a97369b3a6ee159b307f7cc876bbb4facdbba66"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 sonoma:       "c230208074feda97c361199781940d50f7918419802ec903eec833d3ff2c0af0"
    sha256 ventura:      "2c6365b16dbb1c3e70acd5068dfeab479f0742d8c9ae8df40df40af5524b119d"
    sha256 monterey:     "81ce3aecfc6b2f110322459cbdde89176590fe8e445d75ca7136dfec520c7f4d"
    sha256 x86_64_linux: "e4140dea7a57faf9c5f5adcd2a5b8803f7e19ba989c7f375c73d84a2d3459010"
  end

  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "boost"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
  end

  resource "rom" do
    url "https:github.commupen64plusmupen64plus-romraw76ef14c876ed036284154444c7bdc29d19381accm64p_test_rom.v64"
    sha256 "b5fe9d650a67091c97838386f5102ad94c79232240f9c5bcc72334097d76224c"
  end

  def install
    # Work around build failure with `boost` 1.85.0
    # Issue ref: https:github.commupen64plusmupen64plus-video-glide64mk2issues128
    wpath_files = %w[
      sourcemupen64plus-video-glide64mk2srcGlideHQTxCache.cpp
      sourcemupen64plus-video-glide64mk2srcGlideHQTxHiResCache.cpp
      sourcemupen64plus-video-glide64mk2srcGlideHQTxHiResCache.h
      sourcemupen64plus-video-glide64mk2srcGlideHQTxTexCache.cpp
    ]
    inreplace wpath_files, \bboost::filesystem::wpath\b, "boost::filesystem::path"
    inreplace "sourcemupen64plus-video-glide64mk2srcGlideHQTxHiResCache.cpp",
              "->path().leaf().", "->path().filename()."

    # Prevent different C++ standard library warning
    if OS.mac?
      inreplace Dir["sourcemupen64plus-**projectsunixMakefile"],
                (-mmacosx-version-min)=\d+\.\d+,
                "\\1=#{MacOS.version}"
    end

    # Fix build with Xcode 9 using upstream commit:
    # https:github.commupen64plusmupen64plus-video-glide64mk2commit5ac11270
    # Remove in next version
    inreplace "sourcemupen64plus-video-glide64mk2srcGlide643dmath.cpp",
              "__builtin_ia32_storeups", "_mm_storeu_ps"

    if OS.linux?
      ENV.append "CFLAGS", "-fcommon"
      ENV.append "CFLAGS", "-fpie"
    end

    args = ["install", "PREFIX=#{prefix}", "COREDIR=#{lib}"]
    args << if OS.mac?
      "INSTALL_STRIP_FLAG=-S"
    else
      "USE_GLES=1"
    end

    cd "sourcemupen64plus-coreprojectsunix" do
      system "make", *args
    end

    cd "sourcemupen64plus-audio-sdlprojectsunix" do
      system "make", *args, "NO_SRC=1", "NO_SPEEX=1"
    end

    cd "sourcemupen64plus-input-sdlprojectsunix" do
      system "make", *args
    end

    cd "sourcemupen64plus-rsp-hleprojectsunix" do
      system "make", *args
    end

    cd "sourcemupen64plus-video-glide64mk2projectsunix" do
      system "make", *args
    end

    cd "sourcemupen64plus-video-riceprojectsunix" do
      system "make", *args
    end

    cd "sourcemupen64plus-ui-consoleprojectsunix" do
      system "make", *args, "PIE=1"
    end
  end

  test do
    # Disable test in Linux CI because it hangs because a display is not available.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    resource("rom").stage do
      system bin"mupen64plus", "--testshots", "1",
             "m64p_test_rom.v64"
    end
  end
end