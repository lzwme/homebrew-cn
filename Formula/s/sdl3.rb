class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-3.2.2SDL3-3.2.2.tar.gz"
  sha256 "d3dcf1b2f64746be0f248ef27b35aec4f038dafadfb83491f98a7fecdaf6efec"
  license "Zlib"
  head "https:github.comlibsdl-orgSDL.git", branch: "main"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a39d5efa55aef1677d8fd9895843e23ac4e09d5fa394033bfa45a88735bc371a"
    sha256 cellar: :any,                 arm64_sonoma:  "454ee098a5d0b4e5e075ee5158945682b2343ec207fac0a0d74d86516fb8eab5"
    sha256 cellar: :any,                 arm64_ventura: "00a0838140cc15832d4062b6c7b76a34e9b2d16a01dec05b8eb53a4cfafdfdcb"
    sha256 cellar: :any,                 sonoma:        "af211d978f9dbe9074b3d329e9d9e07a8077390423177b211953c3c76c43cfd6"
    sha256 cellar: :any,                 ventura:       "abb43266dd0cb892c7c3c9beb19c2c55538cd90b0280daff0d9f4bdea36cb633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1c90b5659063292888bd66394422b5247d5569eb62a7ecd04e73c59b28c2716"
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