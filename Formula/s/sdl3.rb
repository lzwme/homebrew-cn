class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://ghfast.top/https://github.com/libsdl-org/SDL/releases/download/release-3.4.6/SDL3-3.4.6.tar.gz"
  sha256 "96bdd3f0c442105c87c287d213858b2df8207c87d54991dd589078c3746cb386"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5edcdd2c396ea94ca7684ffba3c5112dd6a450aa9070cbef75fc84a47238109"
    sha256 cellar: :any,                 arm64_sequoia: "7577978ff96e07f43b065333ea81bc04157489fb4001f5444380a03931f548e2"
    sha256 cellar: :any,                 arm64_sonoma:  "4c5d9ac4d0f1ab4fb3877c0752cdfe9f64e759be52014bf552c9adace6e0d21f"
    sha256 cellar: :any,                 sonoma:        "c7ee7aad5c124ea54e35adf151340d4d57b1612ec28a9554018d2f70d9f297a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf56574defb234f601fa87afaeac21229c8d5f063bb02d45194d95cb9a38d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b6c020d9a5644bc9f40477e56d272197f1e8135ffcc1ddd0eb8e8efc29aa9ac"
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

    args = %w[
      -DSDL_HIDAPI=ON
      -DSDL_WAYLAND=OFF
      -DSDL_X11_XTEST=OFF
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