class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-3.2.4SDL3-3.2.4.tar.gz"
  sha256 "2938328317301dfbe30176d79c251733aa5e7ec5c436c800b99ed4da7adcb0f0"
  license "Zlib"
  head "https:github.comlibsdl-orgSDL.git", branch: "main"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d81ba62f36a806ef3134d93f91fd3434aa29e52802179c79b731679b5240bb2"
    sha256 cellar: :any,                 arm64_sonoma:  "a70b7313235cf2b3b75db0794f84cba21c643fa9a76ca372964079a14df750bd"
    sha256 cellar: :any,                 arm64_ventura: "95b0232ae1ed7b13c1d83fb8e3c5eb004c2f0b125259888f374f65770ae595a5"
    sha256 cellar: :any,                 sonoma:        "11d5f3f8225328a52ea607214d4ba0dbead65c675e0db9edba4b2f09781be201"
    sha256 cellar: :any,                 ventura:       "10ea4af0d5b1b6ffb090cc1a52ddd73b1b616a8c057ce451f407a2e05c92c411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afd857765284ff2311b9a1c90634188299c2faa51892a6c86921ae397c4e78a1"
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