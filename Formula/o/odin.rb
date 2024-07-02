class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2024-07",
      revision: "b4ca044ae024863fe8c8defbdd603d96f7ab466c"
  version "2024-07"
  license "BSD-3-Clause"
  head "https:github.comodin-langOdin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a2686404c4947ad1d4a66f455d44607826b6ab7d8bb5f7e9a8b0c4682c578b3"
    sha256 cellar: :any,                 arm64_ventura:  "a4ccc9c6eb57dac7fd116ee27eb75eaf7a9a8a022db1bf713547cdf78d30ec49"
    sha256 cellar: :any,                 arm64_monterey: "3189ac689240b17e9b32ca13d07d946df65b56bc4fc515baa403265ac798f9e1"
    sha256 cellar: :any,                 sonoma:         "249a1d13354957f4eeaae1a602a2b4f79aae3161e0a8cc716c9b9343d15f8e70"
    sha256 cellar: :any,                 ventura:        "5418eb9b29a92f42745d96104d3929a22d03d77ddc8994e54eea6467c8a7c13c"
    sha256 cellar: :any,                 monterey:       "c7674272567736f28875caf1f672ad0fa9aa28b0e1185a1873a4f42b1622e93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c8516ac6f0894244df53a692677fa1838c5a756a22d598487f0b35daccd27a9"
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