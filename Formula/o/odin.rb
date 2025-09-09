class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2025-09",
      revision: "42c2cb89b580acc228a5e54988b40cf56f99c95f"
  version "2025-09"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_sequoia: "a5e498ca1c762ba9d686e021a65ccb1c4c7584358189d27ba48f6604e9087b19"
    sha256                               arm64_sonoma:  "796b8b218680d84461462926b6b26b3a00f5393fb3b0d0ff633667d436f4ba22"
    sha256                               arm64_ventura: "59576eb80dc97be7ce3c8528e8d789c676957189e20c164f2c635021ae8f5977"
    sha256 cellar: :any,                 sonoma:        "79e078fb35c88c9f2ab4bd5d49e8d2dcad5e141c2ecbcb12fcff24eb16db2dd6"
    sha256 cellar: :any,                 ventura:       "a6ecb98d0909f15d9000e4c932e1a5ce9549f03046025bb1bd29ba76eb42b926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f33f23f9b19d1b0523a2b903c4e161f572e8d65852206341692f202276e0d983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db190cc3a1efccc1e55cae3925b5185f49429724a2632d912e6f4453163cb2d"
  end

  depends_on "glfw"
  depends_on "lld@20"
  depends_on "llvm@20"
  depends_on "raylib"

  resource "raygui" do
    url "https://ghfast.top/https://github.com/raysan5/raygui/archive/refs/tags/4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV.llvm_clang if OS.linux?
    ENV["LLVM_CONFIG"] = (llvm.opt_bin/"llvm-config").to_s
    ENV.append "LDFLAGS", "-Wl,-rpath,#{llvm.opt_lib}" if OS.linux?

    # Delete pre-compiled binaries which brew does not allow.
    buildpath.glob("vendor/**/*.{lib,dll,a,dylib,so,so.*}").map(&:unlink)

    cd buildpath/"vendor/miniaudio/src" do
      system "make"
    end

    cd buildpath/"vendor/stb/src" do
      system "make", "unix"
    end

    cd buildpath/"vendor/cgltf/src" do
      system "make", "unix"
    end

    raylib_installpath = if OS.linux?
      "vendor/raylib/linux"
    else
      "vendor/raylib/macos"
    end

    raygui_installpath = if OS.linux?
      "vendor/raylib/linux"
    elsif Hardware::CPU.intel?
      "vendor/raylib/macos"
    else
      "vendor/raylib/macos-arm64"
    end

    glfw_installpath = if OS.linux?
      "vendor/glfw/lib"
    else
      "vendor/glfw/lib/darwin"
    end

    ln_s Formula["glfw"].lib/"libglfw3.a", buildpath/glfw_installpath/"libglfw3.a"

    ln_s Formula["raylib"].lib/"libraylib.a", buildpath/raylib_installpath/"libraylib.a"
    # In order to match the version 500 used in odin
    ln_s Formula["raylib"].lib/shared_library("libraylib", "5.5.0"),
      buildpath/raylib_installpath/shared_library("libraylib", "550")

    resource("raygui").stage do
      cp "src/raygui.h", "src/raygui.c"

      # build static library
      system ENV.cc, "-c", "-o", "raygui.o", "src/raygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
      system "ar", "-rcs", "libraygui.a", "raygui.o"
      cp "libraygui.a", buildpath/raygui_installpath

      # build shared library
      args = [
        "-o", shared_library("libraygui"),
        "src/raygui.c",
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
      cp shared_library("libraygui"), buildpath/raygui_installpath
    end

    # By default the build runs an example program, we don't want to run it during install.
    # This would fail when gcc is used because Odin can be build with gcc,
    # but programs linked by Odin need clang specifically.
    inreplace "build_odin.sh", /^\s*run_demo\s*$/, ""

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" if build.stable?
    system "make", "release", *args
    libexec.install "odin", "core", "shared", "base", "vendor"
    (bin/"odin").write <<~BASH
      #!/bin/bash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a "${0}" "#{libexec}/odin" "${@}"
    BASH
    pkgshare.install "examples"
  end

  test do
    (testpath/"hellope.odin").write <<~ODIN
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    ODIN
    system bin/"odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output("./hellope")

    (testpath/"miniaudio.odin").write <<~ODIN
      package main

      import "core:fmt"
      import "vendor:miniaudio"

      main :: proc() {
        ver := miniaudio.version_string()
        assert(len(ver) > 0)
        fmt.println(ver)
      }
    ODIN
    system bin/"odin", "run", "miniaudio.odin", "-file"

    (testpath/"raylib.odin").write <<~ODIN
      package main

      import rl "vendor:raylib"

      main :: proc() {
        // raygui.
        assert(!rl.GuiIsLocked())

        // raylib.
        num := rl.GetRandomValue(42, 1337)
        assert(42 <= num && num <= 1337)
      }
    ODIN
    system bin/"odin", "run", "raylib.odin", "-file"

    if OS.mac?
      system bin/"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"
    end

    (testpath/"glfw.odin").write <<~ODIN
      package main

      import "core:fmt"
      import "vendor:glfw"

      main :: proc() {
        fmt.println(glfw.GetVersion())
      }
    ODIN
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["glfw"].lib if OS.linux?
    system bin/"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=true",
      "-extra-linker-flags:\"-L#{Formula["glfw"].lib}\""
    system bin/"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=false"
  end
end