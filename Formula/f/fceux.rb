class Fceux < Formula
  desc "All-in-one NESFamicom Emulator"
  homepage "https:fceux.com"
  license "GPL-2.0-only"
  revision 4
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

    # x265 4.0 build patch, upstream pr ref, https:github.comTASEmulatorsfceuxpull766
    patch do
      url "https:github.comTASEmulatorsfceuxcommit7d5960fe4037f673b4a644af18b663efe215a24d.patch?full_index=1"
      sha256 "eb16bd9673645a74b1797914564e3fc3867594332334d5921791e7f97f8d36b4"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "c3594d0215425a0e72abe7c7234eaba3dfa46b85dc4dd01ba03dd0f1a422a50e"
    sha256 cellar: :any,                 arm64_ventura: "ac3ba77489705d69cb38841e46e6387c1f4e0296a0850b86371d428240325d56"
    sha256 cellar: :any,                 sonoma:        "fe93346ca1683b5dcecb5cf4df2296ea345422354b46714c1f1365a8a962c71c"
    sha256 cellar: :any,                 ventura:       "bfb3e74a9bb2ebacd321c553eb170991e16fc361c547ae56887b61360b355f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5e0fd981b3b0245b4b9df311b69fb00fe65fe652622a8d3d30f24d0b18fc44"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
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