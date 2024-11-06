class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2024-11",
      revision: "e6475fec4d2a3e34099b24a7a3bf890c7a3ef8d9"
  version "2024-11"
  license "BSD-3-Clause"
  head "https:github.comodin-langOdin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a91650f6f1f162e4f97edb3eb37ff405a4b3489879fea827b59d60de897f1611"
    sha256 cellar: :any,                 arm64_sonoma:  "e0e206de0cb654f640506f8c290a4cd9adbbc3b6dfe922514eaf001a38bbaecc"
    sha256 cellar: :any,                 arm64_ventura: "b3aa71ba40266020de5094de62da209d8636c80ff468c236e0c6b5fe9e657284"
    sha256 cellar: :any,                 sonoma:        "6aaa0043560c7a7350b340dc84f98883536fbfd023a1a4d0ccd3f99a8e592105"
    sha256 cellar: :any,                 ventura:       "681e64950b8d627be9441afade8a93730ae9dcd2049d4dd56382cd95b331d3eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5525674250061c026a799c4007e9e75a0ec4a72c46540464ca341874b3fe5ad6"
  end

  depends_on "glfw"
  depends_on "llvm@18"
  depends_on "raylib"

  fails_with gcc: "5" # LLVM is built with GCC

  resource "raygui" do
    url "https:github.comraysan5rayguiarchiverefstags4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+(\.\d+)*)?$) }
    ENV["LLVM_CONFIG"] = (llvm.opt_bin"llvm-config").to_s

    # Delete pre-compiled binaries which brew does not allow.
    buildpath.glob("vendor***.{lib,dll,a,dylib,so,so.*}").map(&:unlink)

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

    glfw_installpath = if OS.linux?
      "vendorglfwlib"
    else
      "vendorglfwlibdarwin"
    end

    ln_s Formula["glfw"].lib"libglfw3.a", buildpathglfw_installpath"libglfw3.a"

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
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["glfw"].lib if OS.linux?
    system bin"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=true",
      "-extra-linker-flags:\"-L#{Formula["glfw"].lib}\""
    system bin"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=false"
  end
end