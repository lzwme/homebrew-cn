class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2024-04",
      revision: "a00d96c0de2c0b6e4df76e58c1c394373e173751"
  version "2024-04"
  license "BSD-3-Clause"
  head "https:github.comodin-langOdin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "69772c18d8ea2aae20930d3e5d5f255df3cb94ac176d4757b94c90ad7bfaaa7d"
    sha256 cellar: :any,                 arm64_ventura:  "3f6e36d15ebb7fe1b77826cea3c6b0138129e5cc773cd9177ecccf1d79502b47"
    sha256 cellar: :any,                 arm64_monterey: "9f7d1000787cd6ad62a66268a9886685391b0747c000b8892855e5099b6346d4"
    sha256 cellar: :any,                 sonoma:         "00df23c0aa654dc6ce628b0b9d51e5729b75b22fc60715ac3060c2b5c5b60f19"
    sha256 cellar: :any,                 ventura:        "514fd450fc39bf728dc202a3eb078b7c935d803c564752ba91d2e969f9645497"
    sha256 cellar: :any,                 monterey:       "534aedb871b2385b1cceaae0c1a56656d5605c92135b82586191c2acecc0dd0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e5a93cc254580f70b8e720fd180fca456da984427c060b9e2aa43aa2acf118"
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
    system "#{bin}odin", "build", "hellope.odin", "-file"
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
    system "#{bin}odin", "run", "miniaudio.odin", "-file"

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
      system "#{bin}odin", "run", "raylib.odin", "-file"
      system "#{bin}odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"

      (testpath"glfw.odin").write <<~EOS
        package main

        import "core:fmt"
        import "vendor:glfw"

        main :: proc() {
          fmt.println(glfw.GetVersion())
        }
      EOS
      system "#{bin}odin", "run", "glfw.odin", "-file"
    end
  end
end