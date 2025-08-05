class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://ghfast.top/https://github.com/libsdl-org/SDL/releases/download/release-3.2.20/SDL3-3.2.20.tar.gz"
  sha256 "467600ae090dd28616fa37369faf4e3143198ff1da37729b552137e47f751a67"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9290c0f8a75009a4c074799833b8ff427797a201f69a931051a636a296cb48d3"
    sha256 cellar: :any,                 arm64_sonoma:  "b1944cd551a27e15b6041aedd3273f5766dcd18551168c943f20177c2fdd908d"
    sha256 cellar: :any,                 arm64_ventura: "69a898e6743ade46e4642cc35ca9b228f474f61dd63ff48068b808add66cd1d0"
    sha256 cellar: :any,                 sonoma:        "48b8a7901b191265056021d34ca78599b33f5713ff600022b3a4dcea393837ea"
    sha256 cellar: :any,                 ventura:       "70a1519a3d2922a0ea1148748cd059a30c5e0f16917b65ed1bc784310516ef81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b4e680681508d50fe8cd68996937cd07f1fe083b616998f3d5087a87c762f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c9a216f9229c78544fd96f3f36903674d4bf5573cbd4f8fae1c40126970733a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "pulseaudio"
    depends_on "xinput"
  end

  def install
    inreplace "cmake/sdl3.pc.in", "@SDL_PKGCONFIG_PREFIX@", HOMEBREW_PREFIX

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
    (testpath/"test.c").write <<~CPP
      #include <SDL3/SDL.h>
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
    system "./test"
  end
end