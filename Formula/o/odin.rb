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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ab56c361293b37e438e208570b0b0672bd7880fb8f34ba16dcde72e59a538263"
    sha256 cellar: :any,                 arm64_ventura:  "0315ddfb713a361af3e9f718e0e2589af867b1fa6f5938a59bd38062f1b0001c"
    sha256 cellar: :any,                 arm64_monterey: "3fbf54dc55468e995f7197377f4c25bd1dddbbc965976183a6685518c7e3ee38"
    sha256 cellar: :any,                 sonoma:         "19cfebb66a3aa6270c385a1eadef48b4103bf1cf3cff240fd6d399acb86850a1"
    sha256 cellar: :any,                 ventura:        "4850be318071e3603e3b22c014586a8b59f005d5e7c71ff5c773b2e3392041e0"
    sha256 cellar: :any,                 monterey:       "51e6fa7c53828a3cbc95723dd38a75280fd9a524c5e92962340b692bf2d88392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a007c1c815520797e87fffc4afb8ab140c228332c7b6fd2711396b9230db8850"
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

    raylib_installpath = if OS.linux?
      "vendorrayliblinux"
    elsif Hardware::CPU.intel?
      "vendorraylibmacos"
    else
      "vendorraylibmacos-arm64"
    end

    ln_s Formula["glfw"].lib"libglfw3.a", buildpath"vendorglfwlibdarwinlibglfw3.a"

    ln_s Formula["raylib"].lib"libraylib.a", buildpathraylib_installpath"libraylib.a"
    # This is actually raylib 5.0, but upstream had not incremented this number yet when it released.
    ln_s Formula["raylib"].libshared_library("libraylib", "4.5.0"),
      buildpathraylib_installpathshared_library("libraylib", "500")

    resource("raygui").stage do
      cp "srcraygui.h", "srcraygui.c"

      # build static library
      system ENV.cc, "-c", "-o", "raygui.o", "srcraygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
      system "ar", "-rcs", "libraygui.a", "raygui.o"
      cp "libraygui.a", buildpathraylib_installpath

      # build shared library
      args = [
        "-o", shared_library("libraygui"),
        "srcraygui.c",
        "-shared",
        "-fpic",
        "-DRAYGUI_IMPLEMENTATION",
        "-lm", "-lpthread", "-ldl",
        "-I#{Formula["raylib"].include}",
        "-L#{Formula["raylib"].lib}",
        "-lraylib"
      ]

      args += ["-framework", "OpenGL"] if OS.mac?
      system ENV.cc, *args
      cp shared_library("libraygui"), buildpathraylib_installpath
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

    if OS.mac?
      system bin"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"
    end

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