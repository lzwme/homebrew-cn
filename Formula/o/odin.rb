class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2024-09",
      revision: "16c5c69a4079652e930d897823446b7e7a65bd2f"
  version "2024-09"
  license "BSD-3-Clause"
  head "https:github.comodin-langOdin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7651bdbe15c910bbf6804a358d5cd0fb14ccf7b232608d45379346e198f97efc"
    sha256 cellar: :any,                 arm64_ventura:  "cde7e87c99f0c2a4ac5f4785b1786608cc783eed77e3c1cbfd05797d542cbc15"
    sha256 cellar: :any,                 arm64_monterey: "c4a3a030528ddf0c177d33eead37b52a3942dfe2f391ccd1f6a0d1d7424dbbbf"
    sha256 cellar: :any,                 sonoma:         "2cafdd472b3aeb6f9a463cb7a214ce89adc5d834711dc77f68fd57cc25e4df2f"
    sha256 cellar: :any,                 ventura:        "fb26eff2b09d89cb3f222909f84c1cf6f521f7771ff13bc4e064d83bf3026d50"
    sha256 cellar: :any,                 monterey:       "d823f59698e1d19f2984e94f70b4a16cfef51c42c1216573113c61b0a19e0445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3332faaab6e3c38ca1521f7ca86087ac9d0c127dc2d49d6ce9748fb524099edc"
  end

  depends_on "glfw"
  depends_on "llvm"
  depends_on "raylib"

  fails_with gcc: "5" # LLVM is built with GCC

  resource "raygui" do
    url "https:github.comraysan5rayguiarchiverefstags4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+(\.\d+)*)?$) }

    # Delete pre-compiled binaries which brew does not allow.
    system "find", "vendor",
                   "(",
                     "-name", "*.lib",   "-o",
                     "-name", "*.dll",   "-o",
                     "-name", "*.a",     "-o",
                     "-name", "*.dylib", "-o",
                     "-name", "*.so.*",  "-o",
                     "-name", "*.so",
                   ")",
                   "-delete"

    cd buildpath"vendorminiaudiosrc" do
      system "make"
    end

    cd buildpath"vendorstbsrc" do
      system "make", "unix"
    end

    cd buildpath"vendorcgltfsrc" do
      system "make", "unix"
    end

    if OS.mac?
      raylib_installpath = Hardware::CPU.arm? ? "vendorraylibmacos-arm64" : "vendorraylibmacos"

      ln_s Formula["glfw"].lib"libglfw3.a", buildpath"vendorglfwlibdarwinlibglfw3.a"

      ln_s Formula["raylib"].lib"libraylib.a", buildpathraylib_installpath"libraylib.a"
      # This is actually raylib 5.0, but upstream had not incremented this number yet when it released.
      ln_s Formula["raylib"].lib"libraylib.4.5.0.dylib", buildpathraylib_installpath"libraylib.500.dylib"

      resource("raygui").stage do
        cp "srcraygui.h", "srcraygui.c"

        # build static library
        system ENV.cc, "-c", "-o", "raygui.o", "srcraygui.c",
          "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
        system "ar", "-rcs", "libraygui.a", "raygui.o"
        cp "libraygui.a", buildpathraylib_installpath

        # build shared library
        system ENV.cc, "-o", "libraygui.dylib", "srcraygui.c",
          "-shared", "-fpic", "-DRAYGUI_IMPLEMENTATION", "-framework", "OpenGL",
          "-lm", "-lpthread", "-ldl",
          "-I#{Formula["raylib"].include}", "-L#{Formula["raylib"].lib}", "-lraylib"
        cp "libraygui.dylib", buildpathraylib_installpath
      end
    end

    # By default the build runs an example program, we don't want to run it during install.
    # This would fail when gcc is used because Odin can be build with gcc,
    # but programs linked by Odin need clang specifically.
    inreplace "build_odin.sh", ^\s*run_demo\s*$, ""

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" unless build.head?
    system "make", "release", *args
    libexec.install "odin", "core", "shared", "base", "vendor"
    (bin"odin").write <<~EOS
      #!binbash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    (testpath"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system bin"odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output(".hellope")

    (testpath"miniaudio.odin").write <<~EOS
      package main

      import "core:fmt"
      import "vendor:miniaudio"

      main :: proc() {
        ver := miniaudio.version_string()
        assert(len(ver) > 0)
        fmt.println(ver)
      }
    EOS
    system bin"odin", "run", "miniaudio.odin", "-file"

    if OS.mac?
      (testpath"raylib.odin").write <<~EOS
        package main

        import rl "vendor:raylib"

        main :: proc() {
           raygui.
          assert(!rl.GuiIsLocked())

           raylib.
          num := rl.GetRandomValue(42, 1337)
          assert(42 <= num && num <= 1337)
        }
      EOS
      system bin"odin", "run", "raylib.odin", "-file"
      system bin"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"

      (testpath"glfw.odin").write <<~EOS
        package main

        import "core:fmt"
        import "vendor:glfw"

        main :: proc() {
          fmt.println(glfw.GetVersion())
        }
      EOS
      system bin"odin", "run", "glfw.odin", "-file"
    end
  end
end