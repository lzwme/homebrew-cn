class Fceux < Formula
  desc "All-in-one NESFamicom Emulator"
  homepage "https:fceux.com"
  license "GPL-2.0-only"
  revision 2
  head "https:github.comTASEmulatorsfceux.git", branch: "master"

  stable do
    url "https:github.comTASEmulatorsfceux.git",
        tag:      "v2.6.6",
        revision: "34eb7601c415b81901fd02afbd5cfdc84b5047ac"

    # patch for `New timeStamp.cpp file renders fceux x86-only` issue
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patchescd40795fceux2.6.6-arm.patch"
      sha256 "0890494f4b5db5fa11b94e418d505cea87dc9b9f55cdc6c97e9b5699aeada4ac"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bfa825bc1b802bef0d363c3583d2b764003374b304b157a3e3cb60d8957906a6"
    sha256 cellar: :any,                 arm64_ventura:  "20605deb4c81f581cf24f486481c6fd5a1a5d2c4f2c83cc83b099d970c276b24"
    sha256 cellar: :any,                 arm64_monterey: "220b5099f902a7285fe7c25aebedb8160eef3d5d46bb5658a584faef9c50eb82"
    sha256 cellar: :any,                 sonoma:         "c069a6d8df8620c67847c31a30940d85e5a8bf17be80ed33fb80135dc2d3eede"
    sha256 cellar: :any,                 ventura:        "99f19db1ae480c85e5296511a4a549d3e0c15281d654e937e0dd6a0f06f623b1"
    sha256 cellar: :any,                 monterey:       "3417ac4e49dfff539e550dbde05e59ad12d51fd3c1a3ecce532ea6e03950731f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "780831f1198865742b0547c7774bcfa8d0453c6bad9f759753853f11c7038d5d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg@6"
  depends_on "libarchive"
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "x264"
  depends_on "x265"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib"
  end

  fails_with gcc: "5"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
    system "make"
    cp "srcauxlib.lua", "outputluaScripts"
    fceux_path = OS.mac? ? "srcfceux.appContentsMacOS" : "src"
    libexec.install Pathname.new(fceux_path)"fceux"
    pkgshare.install ["outputluaScripts", "outputpalettes", "outputtools"]
    (bin"fceux").write <<~EOS
      #!binbash
      LUA_PATH=#{pkgshare}luaScripts?.lua #{libexec}fceux "$@"
    EOS
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"fceux", "--help"
  end
end