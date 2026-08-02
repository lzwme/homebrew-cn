class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2026-07a",
      revision: "819fdc7a80667498b8b365999f1475a66c358640"
  version "2026-07a"
  license "Zlib"
  revision 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "a1a0603e35977cca316e09152080c2a5e02a37be76652ed0b93d9ea2a54a5193"
    sha256               arm64_sequoia: "74ed86b54d38ac46c65ec1a272137408204611091b0d394c593b797888272ac3"
    sha256               arm64_sonoma:  "061e23e29a9e94470bf8b6d5847f1e1ad64fd4f9789a0363c8645172c9a0c631"
    sha256 cellar: :any, sonoma:        "d93e507101b7052c10de27ee035ddb81e3120ec99ecb76941a59876f5cb80636"
    sha256 cellar: :any, arm64_linux:   "d1b67e284501b0fce321c3b41723b8c7922bddf6002bff137c9a2a64e0bd4880"
    sha256 cellar: :any, x86_64_linux:  "1b01318280242daf1815d22a6311835f1a82675916f7a9b4dcfef12cef276af8"
  end

  depends_on "glfw" => :no_linkage
  depends_on "lld"
  depends_on "llvm"
  depends_on "raylib"

  fails_with :gcc do
    cause "requires Clang"
  end

  resource "raygui" do
    url "https://ghfast.top/https://github.com/raysan5/raygui/archive/refs/tags/4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
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

    glfw_installpath = if OS.linux?
      "vendor/glfw/lib"
    else
      "vendor/glfw/lib/darwin"
    end
    ln_s Formula["glfw"].lib/"libglfw3.a", buildpath/glfw_installpath/"libglfw3.a"

    # glfw 3.5 references `CAMetalLayer` directly, so static links need QuartzCore
    if OS.mac?
      inreplace "vendor/glfw/bindings/bindings.odin", "\"../lib/darwin/libglfw3.a\",",
                "\\0\n\t\t\t\"system:QuartzCore.framework\","
    end

    raylib = Formula["raylib"]
    vendor = buildpath/"vendor/raylib"

    # Odin's `vendor:raylib` bindings link raylib from fixed per-OS/arch dirs
    static_dir, shared_dir = if OS.mac?
      ["macos", "macos"]
    elsif Hardware::CPU.arm?
      ["linux-arm", "linux-arm64"]
    else
      ["linux", "linux"]
    end

    (vendor/static_dir).mkpath # linux-arm is not shipped in the checkout
    ln_s raylib.lib/"libraylib.a", vendor/static_dir/"libraylib.a"
    ln_s raylib.lib/shared_library("libraylib", "6.0.0"),
         vendor/shared_dir/shared_library("libraylib", "600")

    raygui_dir = vendor/(OS.mac? ? "macos" : "linux")
    raygui_name = (OS.mac? && Hardware::CPU.arm?) ? "libraygui-arm64" : "libraygui"

    resource("raygui").stage do
      cp "src/raygui.h", "src/raygui.c"

      system ENV.cc, "-c", "-o", "raygui.o", "src/raygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{raylib.include}"
      system "ar", "-rcs", "#{raygui_name}.a", "raygui.o"
      cp "#{raygui_name}.a", raygui_dir

      args = [
        "-o", shared_library(raygui_name),
        "src/raygui.c",
        "-shared",
        "-fpic",
        "-DRAYGUI_IMPLEMENTATION",
        "-lm", "-lpthread", "-ldl",
        "-I#{raylib.include}",
        "-L#{raylib.lib}",
        "-lraylib"
      ]
      args += ["-framework", "OpenGL"] if OS.mac?
      system ENV.cc, *args
      cp shared_library(raygui_name), raygui_dir
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
    # raylib's bindings link libX11 on Linux; make it loadable at runtime.
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["libx11"].lib if OS.linux?
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