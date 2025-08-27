class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license "GPL-2.0-only"
  revision 6
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  stable do
    url "https://github.com/TASEmulators/fceux.git",
        tag:      "v2.6.6",
        revision: "34eb7601c415b81901fd02afbd5cfdc84b5047ac"

    # patch for `New timeStamp.cpp file renders fceux x86-only` issue
    patch do
      url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/cd40795/fceux/2.6.6-arm.patch"
      sha256 "0890494f4b5db5fa11b94e418d505cea87dc9b9f55cdc6c97e9b5699aeada4ac"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "23913d3f22174dd8b83cfa7ed839806fdc6cf37e4c9aac9196905f84d32948bd"
    sha256 cellar: :any,                 arm64_ventura: "bf2bddc92fe28cdc5ab038e83562eeaa000bdc8c72a6dacb5f4f121147a444fb"
    sha256 cellar: :any,                 sonoma:        "cabcc1c8f960529d4ce0167b63d8ccb1f1a946e9b7c3b9fc723b1232dc520f6f"
    sha256 cellar: :any,                 ventura:       "697626515145a318065d71652a90380f234f1e87dddf5ec7d64bfbce494ce604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1bf359604aa56c298ded5ff8ea1822b40d43066f24d76d7eaa284d365594a3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
    fceux_path = OS.mac? ? "src/fceux.app/Contents/MacOS" : "src"
    libexec.install Pathname.new(fceux_path)/"fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~BASH
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    BASH
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"fceux", "--help"
  end
end