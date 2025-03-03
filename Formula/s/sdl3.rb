class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-3.2.6SDL3-3.2.6.tar.gz"
  sha256 "096a0b843dd1124afda41c24bd05034af75af37e9a1b9d205cc0a70193b27e1a"
  license "Zlib"
  head "https:github.comlibsdl-orgSDL.git", branch: "main"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e59cef196344b5586b396ccfc1e4b449ebe3d5f1fc46082623d00b530d35b78"
    sha256 cellar: :any,                 arm64_sonoma:  "3962edf9e10486839a270f9391325e1241f8d5cea9dc14b9f8e29a19e2749677"
    sha256 cellar: :any,                 arm64_ventura: "4ba179f9710461f8af8ff78dc5105f090296d762805473dfd568d73de5618be7"
    sha256 cellar: :any,                 sonoma:        "deb27d834eba7c77c5b0c9ce6aae471fdfc898f78daa5ae62b709ee4d9ab3153"
    sha256 cellar: :any,                 ventura:       "a610d6cf2ebd3bfa0f3d5674cdb028857702865a4e882633cb410b1943475855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5463c8faf86df9214f14c8797e6ce8f5bb5991264339bc805794e2d2ce680112"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "pulseaudio"
    depends_on "xinput"
  end

  def install
    inreplace "cmakesdl3.pc.in", "@SDL_PKGCONFIG_PREFIX@", HOMEBREW_PREFIX

    args = [
      "-DSDL_HIDAPI=ON",
      "-DSDL_WAYLAND=OFF",
    ]

    args += if OS.mac?
      ["-DSDL_X11=OFF"]
    else
      ["-DSDL_X11=ON", "-DSDL_PULSEAUDIO=ON"]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~CPP
      #include <SDL3SDL.h>
      int main() {
        if (SDL_Init(SDL_INIT_VIDEO) != 1) {
          return 1;
        }
        SDL_Quit();
        return 0;
      }
    CPP
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lSDL3", "-o", "test"
    ENV["SDL_VIDEODRIVER"] = "dummy"
    system ".test"
  end
end