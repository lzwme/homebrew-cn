class Fceux < Formula
  desc "All-in-one NESFamicom Emulator"
  homepage "https:fceux.com"
  license "GPL-2.0-only"
  revision 1
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
    sha256 cellar: :any,                 arm64_sonoma:   "bf4c5bea72673eea70a819c2a667fc40ba6f9bacac4bd9da7580ef11d75aa4a8"
    sha256 cellar: :any,                 arm64_ventura:  "8ee1fd549945d66232807b27ec188df73b068a7fd4d37e145923b6f8611bdf0e"
    sha256 cellar: :any,                 arm64_monterey: "1710ab03bf838527371bf17a73522e74dc0145216cef8948e93393fa5f5425cf"
    sha256 cellar: :any,                 sonoma:         "3d6cba56c1269192e9d92f1a0f887ed9cf97e18bdcf294c574e2a964c905d5cb"
    sha256 cellar: :any,                 ventura:        "07c9ddb45c4a6690291a0d5b0434b7bad2d759e57407f59aca299bc7078c3c83"
    sha256 cellar: :any,                 monterey:       "73e62b4caf6d77a33a952e46a29366fd7d023523d633eb9ee940d7eef686abe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab40549fd9e0219a65e8a9af0228992d29cf7708376e8c858aed071389ae3dde"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "x264"

  on_linux do
    depends_on "mesa-glu"
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

    system "#{bin}fceux", "--help"
  end
end