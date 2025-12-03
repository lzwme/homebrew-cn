class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://ghfast.top/https://github.com/libsdl-org/SDL/releases/download/release-3.2.28/SDL3-3.2.28.tar.gz"
  sha256 "1330671214d146f8aeb1ed399fc3e081873cdb38b5189d1f8bb6ab15bbc04211"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd2d0308f00a1c98d4c920d715bc0baa8f1cafdeacec940900df5375632bf30f"
    sha256 cellar: :any,                 arm64_sequoia: "4eab5d1cad2fa77fb44a9a094a4a7fb619e5af5a9f5aaa860f18c53ed7026d75"
    sha256 cellar: :any,                 arm64_sonoma:  "17d22371b1da29f5febee3ed87298861b3b5dc5bbd41a8543f2e271397ee609b"
    sha256 cellar: :any,                 sonoma:        "9f1eb3709e6c5df868952b37a8ef3cc0514c4fe956b1fa91f1e96fe1f1a1dad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5565a534ecbbbae6fb2253dd9519677c20c4fd38e31880756f919144f845812b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94a19c576075a0562b8c7f98f010efa47693aa47d65f4e4e55ed76f0131b46f3"
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