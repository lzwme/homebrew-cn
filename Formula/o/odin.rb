class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https:odin-lang.org"
  url "https:github.comodin-langOdin.git",
      tag:      "dev-2025-02",
      revision: "584fdc0d4ab9dcc01e218e499fdaef9969223d65"
  version "2025-02"
  license "BSD-3-Clause"
  head "https:github.comodin-langOdin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bfd4fda54aaca18281829f65d9f5838b504fc195808ddf618601f65526cc89e1"
    sha256 cellar: :any,                 arm64_sonoma:  "eabbee587494f382dcdfed775c15f8496204ab4f6a2e516544d20671405e0355"
    sha256 cellar: :any,                 arm64_ventura: "5e1cd30876b826e47ba7553ecb00c556a87a420d1699f8c000ab20ddea96a8a6"
    sha256 cellar: :any,                 sonoma:        "3ca0a95c444acbcc212f0d9828a57c5af890be43b54641c16f4c986083d14698"
    sha256 cellar: :any,                 ventura:       "7f5802fbac7a3634ac2e8905ffd3da52ac41a6a00dba03a13389c31f4bc220d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "addb05b9b538535055b9f0c21f5788d0e81367b80efeb1b62afb6a1ddfd56f7c"
  end

  depends_on "glfw"
  depends_on "llvm"
  depends_on "raylib"

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
    else
      "vendorraylibmacos"
    end

    raygui_installpath = if OS.linux?
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
    # In order to match the version 500 used in odin
    ln_s Formula["raylib"].libshared_library("libraylib", "5.5.0"),
      buildpathraylib_installpathshared_library("libraylib", "550")

    resource("raygui").stage do
      cp "srcraygui.h", "srcraygui.c"

      # build static library
      system ENV.cc, "-c", "-o", "raygui.o", "srcraygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
      system "ar", "-rcs", "libraygui.a", "raygui.o"
      cp "libraygui.a", buildpathraygui_installpath

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
      cp shared_library("libraygui"), buildpathraygui_installpath
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
    (bin"odin").write <<~BASH
      #!binbash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}odin" "$@"
    BASH
    pkgshare.install "examples"
  end

  test do
    (testpath"hellope.odin").write <<~ODIN
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    ODIN
    system bin"odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output(".hellope")

    (testpath"miniaudio.odin").write <<~ODIN
      package main

      import "core:fmt"
      import "vendor:miniaudio"

      main :: proc() {
        ver := miniaudio.version_string()
        assert(len(ver) > 0)
        fmt.println(ver)
      }
    ODIN
    system bin"odin", "run", "miniaudio.odin", "-file"

    (testpath"raylib.odin").write <<~ODIN
      package main

      import rl "vendor:raylib"

      main :: proc() {
         raygui.
        assert(!rl.GuiIsLocked())

         raylib.
        num := rl.GetRandomValue(42, 1337)
        assert(42 <= num && num <= 1337)
      }
    ODIN
    system bin"odin", "run", "raylib.odin", "-file"

    if OS.mac?
      system bin"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"
    end

    (testpath"glfw.odin").write <<~ODIN
      package main

      import "core:fmt"
      import "vendor:glfw"

      main :: proc() {
        fmt.println(glfw.GetVersion())
      }
    ODIN
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["glfw"].lib if OS.linux?
    system bin"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=true",
      "-extra-linker-flags:\"-L#{Formula["glfw"].lib}\""
    system bin"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=false"
  end
end