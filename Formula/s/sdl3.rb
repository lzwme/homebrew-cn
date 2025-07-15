class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://ghfast.top/https://github.com/libsdl-org/SDL/releases/download/release-3.2.18/SDL3-3.2.18.tar.gz"
  sha256 "1a775bde924397a8e0c08bfda198926c17be859d0288ad0dec1dea1b2ee04f8f"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf86a3469d82023acf7377ba68e849badc9827f3f655d0a3438fd5325ca5ec7c"
    sha256 cellar: :any,                 arm64_sonoma:  "22f76d982952ce37cc9632f65bcc5c44da7ac6ed60f1f117e40e0fec87116451"
    sha256 cellar: :any,                 arm64_ventura: "bdb79a484cabc4972f403dd09c744712f913fe8f648273557c2b03eb7ce6253d"
    sha256 cellar: :any,                 sonoma:        "e604c4dcc220b4bbcc7fb57f2be342617d881a4b944f8da3630b657272d6d236"
    sha256 cellar: :any,                 ventura:       "768bcecd51f4bebe8265b0ad5f3ca6fa6d7f3ae534d45fe4e0efe592cc67046c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ae4b84f5ccc9e82d99f3f9168ec390e64d6b70344ebd470d2988eafb95cce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3abd46c9f13741b034792bdbe22ad741c6b20bd057cb13c34f353549328243e"
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